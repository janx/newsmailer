class Feed < ActiveRecord::Base
  has_many :articles
  has_and_belongs_to_many :users
end
