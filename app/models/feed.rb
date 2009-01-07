require 'timeout'
require 'open-uri'

class Feed < ActiveRecord::Base
  has_many :articles
  has_and_belongs_to_many :users

  before_save :unescape_regexp

  def refresh
    Timeout::timeout(35) do
      @result = FeedParser.parse url
    end
    return false if @result.status == '404'

    timestamp = @result.feed.updated_parsed || @result.feed.date_parsed || @result.updated
    timestamp &&= Time.utc(*timestamp[0,8])
    return true if timestamp && modified_at && (modified_at >= timestamp)

    analyzer @result

    self.update_attributes :modified_at => timestamp, :name => @result.feed.title, :description => @result.feed.description

  rescue Timeout::Error
    puts "Timeout when fetching #{self}"
  rescue Exception, RuntimeError
    puts $!.backtrace
    puts "Error: can't parse #{self}"
  end

  def raw
    @result
  end

  def to_s
    "#{name} <#{url}>"
  end

  private

  def analyzer(result)
    for entry in result.entries
      ct, ctnt = get_content(entry)
      options = {:title => entry.title, :content_type => ct, :modified_at => entry.updated_time, :url => entry.link, :content => ctnt, :feed_id => id, :prefetched => prefetched(ctnt)}
      Article.insert options
    end
  end

  def get_content(entry)
    if entry.content && entry.content.first
      [entry.content.first.type, entry.content.first.value]
    elsif entry.summary_detail
      [entry.summary_detail.type, entry.summary_detail.value]
    end
  end

  def prefetched(origin_html)
    return nil unless prefetch?
    result = ""
    origin_html.scan(Regexp.new(prefetch_url_pattern, Regexp::IGNORECASE)).flatten.each do |prefetch_url|
      puts "pre-fetching article #{prefetch_url} ..."
      begin
        Timeout::timeout(30) do
          open(prefetch_url) do |page|
            content = page.read
            result << "<h2><a href='#{prefetch_url}'>Prefetched article</a><h2>" << content
          end
        end
      rescue Timeout::Error
        puts "Timeout when pre-fetching #{prefetch_url}"
      end
    end
    result
  end

  def unescape_regexp
    self.prefetch_url_pattern = prefetch_url_pattern.gsub("\\\\","\\") unless self.prefetch_url_pattern.blank?
  end

end
