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

ActiveRecord::Schema.define(version: 4) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: true do |t|
    t.string  "href"
    t.string  "found_on"
    t.text  "full_path"
    t.text    "content"
    t.integer "page_id"
  end

  create_table "pages", force: true do |t|
    t.text  "href"
    t.text  "title"
    t.text    "description"
    t.integer "site_id"
    t.text    "content"
  end

  create_table "sites", force: true do |t|
    t.string "host_name"
  end

end
