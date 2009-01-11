require 'test_helper'

class FeedFormalizerTest < ActiveSupport::TestCase

  def setup
    @feed = FeedFormalizer.new FeedParser.parse(File.join(RAILS_ROOT, "/test/fixtures/reddit.rss"))
  end

  test "it should return title" do
    assert_equal "programming: what's new online", @feed.title
  end

  test "it should return entries" do
    assert(@feed.entries.size > 0)
    for entry in @feed.entries
      assert entry.title
      assert entry.url
      assert entry.content_type
      assert entry.content
      assert entry.modified_at
    end
  end

end
