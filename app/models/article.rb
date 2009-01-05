class Article < ActiveRecord::Base
  belongs_to :feed

  validates_uniqueness_of :url
end
