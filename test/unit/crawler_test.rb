require 'test_helper'

class CrawlerTest < ActiveSupport::TestCase

  test "slice array" do
    sliced = Crawler.new.send :slice, (1..13).to_a, 4
    assert_equal 4, sliced.size
    assert_equal 4, sliced[0].size
    assert_equal 1, sliced[3].size
  end

end

