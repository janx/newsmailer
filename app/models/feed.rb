require 'timeout'
require 'open-uri'

class Feed < ActiveRecord::Base
  has_many :articles
  has_and_belongs_to_many :users

  validates_uniqueness_of :url

  before_save :unescape_regexp, :unless => Proc.new {|feed| feed.prefetch_url_pattern.blank?}

  PREFETCH_BLACKLIST = /(.pdf)|(.jpg)|(.gif)|(.png)|(.mp3)|(.mp4)|(.flv)|(.mov)$/

  def refresh
    Timeout::timeout(35) do
      @feed = FeedFormalizer.new FeedParser.parse(url)
    end
    return false if @feed.status == '404'

    timestamp = Time.utc(*@feed.timestamp[0,8]) if @feed.timestamp
    return true if timestamp && modified_at && (modified_at >= timestamp)

    for entry in @feed.entries
      Article.insert :title => entry.title, :content_type => entry.content_type, :modified_at => entry.modified_at, :url => entry.url, :content => entry.content, :feed_id => id, :prefetched => prefetched(entry.content)
    end

    self.update_attributes :modified_at => timestamp, :name => @feed.title, :description => @feed.description

  rescue Timeout::Error
    puts "Timeout when fetching #{self}"
  rescue ActiveRecord::ConnectionTimeoutError
    puts "Timeout when acquiring a connection to db: #{$!}"
  rescue Exception, RuntimeError
    puts $!.class.name
    puts $!.backtrace
    puts "Error: can't parse #{self}"
  end

  def raw
    @feed.raw
  end

  def to_s
    "#{name} <#{url}>"
  end

  private

  def prefetched(origin_html)
    return nil unless prefetch?
    result = ""
    origin_html.scan(Regexp.new(prefetch_url_pattern, Regexp::IGNORECASE)).flatten.each do |prefetch_url|
      if prefetch_url =~ PREFETCH_BLACKLIST
        puts "skip pre-fetching #{prefetch_url}"
        return
      end
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
      rescue
        puts "prefetch failed: #{$!}"
      end
    end
    result
  end

  def unescape_regexp
    self.prefetch_url_pattern = prefetch_url_pattern.gsub("\\\\","\\")
  end

end
