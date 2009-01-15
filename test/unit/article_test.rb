require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  should_belong_to :feed

  should_require_unique_attributes :url

  test "title should be unique in the same feed" do
    a = feeds(:one).articles.build :title => 'foobar', :url => '123'
    assert a.save
    a = feeds(:two).articles.build :title => 'foobar', :url => '231'
    assert a.valid?
    a = feeds(:one).articles.build :title => 'foobar', :url => '321'
    assert !a.valid?
  end

end
