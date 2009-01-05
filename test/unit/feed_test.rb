require 'test_helper'

class FeedTest < ActiveSupport::TestCase
  should_have_many :articles
  should_have_and_belong_to_many :users
end
