class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :name
      t.datetime :modified_at
      t.string :url
      t.text :description
      t.string :issued
      t.string :copyright
      t.string :tagline
      t.string :guid

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
