class Article < ActiveRecord::Base
  belongs_to :feed

  validates_uniqueness_of :url

  def send_to(user)
    NewsSender.deliver_news self, user
  end
end
