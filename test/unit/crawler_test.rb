require 'test_helper'

class CrawlerTest < ActiveSupport::TestCase

  test "slice array" do
    sliced = Crawler.new.send :slice, (1..13).to_a, 4
    assert_equal 4, sliced.size
    assert_equal 4, sliced[0].size
    assert_equal 1, sliced[3].size
  end

  test "concurrency save articles" do
    threads = []
    1.upto(5) { |i|
      threads << Thread.new { 
        sleep 3
        1.upto(10) { |j|
          Article.insert :title => "a_#{i}_#{j}", :content_type => 'text/html', :modified_at => Time.now, :url => "http://www.google.com/?x=#{i}&y=#{j}", :content => "#{i} #{j}", :feed_id => 1
        }
      }
    }
    threads.each {|t| t.join}
  end

end

