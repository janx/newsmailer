class AddContentTypeToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :content_type, :string
  end

  def self.down
    remove_column :articles, :content_type
  end
end
