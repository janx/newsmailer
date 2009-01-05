class CreateFeedsUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :feeds_users, :id => false do |t|
      t.integer :feed_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :feeds_users
  end
end
