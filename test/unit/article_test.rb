require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  should_belong_to :feed

  should_require_unique_attributes :url
end
