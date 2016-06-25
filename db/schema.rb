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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160625015721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "friend_and_families", force: :cascade do |t|
    t.integer  "kid_id"
    t.integer  "follower_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "can_create_posts", default: false
  end

  add_index "friend_and_families", ["follower_id", "kid_id"], name: "index_friend_and_families_on_follower_id_and_kid_id", unique: true, using: :btree
  add_index "friend_and_families", ["follower_id"], name: "index_friend_and_families_on_follower_id", using: :btree
  add_index "friend_and_families", ["kid_id"], name: "index_friend_and_families_on_kid_id", using: :btree

  create_table "kids", force: :cascade do |t|
    t.date     "birthdate"
    t.string   "gender"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "created_by"
  end

  create_table "kids_users", id: false, force: :cascade do |t|
    t.integer "kid_id"
    t.integer "user_id"
  end

  add_index "kids_users", ["kid_id"], name: "index_kids_users_on_kid_id", using: :btree
  add_index "kids_users", ["user_id"], name: "index_kids_users_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
    t.integer  "kid_id"
    t.date     "date_said"
    t.boolean  "parents_eyes_only",  default: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "posts", ["kid_id"], name: "index_posts_on_kid_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
end
