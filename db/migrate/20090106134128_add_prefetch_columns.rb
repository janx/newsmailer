class AddPrefetchColumns < ActiveRecord::Migration
  def self.up
    add_column :feeds, :prefetch, :boolean
    add_column :feeds, :prefetch_url_pattern, :string
    add_column :articles, :prefetched, :text
  end

  def self.down
    remove_column :feeds, :prefetch
    remove_column :feeds, :prefetch_url_pattern
    remove_column :articles, :prefetched
  end
end
