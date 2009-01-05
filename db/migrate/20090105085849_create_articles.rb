class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.datetime :modified_at
      t.string :url
      t.integer :feed_id

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
