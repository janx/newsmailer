class AddColumnsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :delivered_at, :datetime, :default => Time.utc(0)
  end

  def self.down
    remove_column :users, :delivered_at
  end
end
