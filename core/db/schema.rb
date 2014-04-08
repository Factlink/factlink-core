# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140407154017) do

  create_table "comments", :force => true do |t|
    t.integer  "fact_data_id"
    t.text     "content"
    t.string   "created_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "comments", ["fact_data_id"], :name => "index_comments_on_fact_data_id"

  create_table "fact_data", :force => true do |t|
    t.text     "title"
    t.text     "displaystring"
    t.text     "site_url"
    t.string   "fact_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "sub_comments", :force => true do |t|
    t.integer  "parent_id"
    t.text     "content"
    t.string   "created_by_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "sub_comments", ["parent_id"], :name => "index_sub_comments_on_parent_id"

end
