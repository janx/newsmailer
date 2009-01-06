# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090106134128) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "modified_at"
    t.string   "url"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
    t.text     "prefetched"
  end

  create_table "feeds", :force => true do |t|
    t.string   "name"
    t.datetime "modified_at"
    t.string   "url"
    t.text     "description"
    t.string   "issued"
    t.string   "copyright"
    t.string   "tagline"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "prefetch"
    t.string   "prefetch_url_pattern"
  end

  create_table "feeds_users", :id => false, :force => true do |t|
    t.integer "feed_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.datetime "delivered_at",                             :default => '2000-01-01 00:00:00'
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
