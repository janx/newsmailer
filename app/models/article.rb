class Article < ActiveRecord::Base
  belongs_to :feed

  validates_uniqueness_of :url
  validates_uniqueness_of :title, :scope => :feed_id

  def self.insert(options)
    if Article.find_by_url(options[:url])
      return false
    else
      Article.create options
    end
  rescue
    puts "failed to insert article: #{$!}"
  end

  def send_to(user)
    NewsSender.deliver_news self, user
  end
end
