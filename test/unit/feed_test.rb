require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  should_have_many :articles
  should_have_and_belong_to_many :users

  test "it should get reddit news" do
    test_feed File.join(RAILS_ROOT, "/test/fixtures/reddit.rss")
  end

  private

  def test_feed url
    feed = Feed.new :name => url, :url => url
    assert feed.save
    assert_equal 0, feed.articles.count
    feed.refresh
    assert(feed.articles.count > 0)
  end

end
