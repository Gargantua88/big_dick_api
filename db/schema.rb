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

ActiveRecord::Schema.define(version: 2019_01_13_130518) do

  create_table "headings", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_headings_on_slug"
    t.index ["title"], name: "index_headings_on_title"
  end

  create_table "materials", force: :cascade do |t|
    t.string "title"
    t.text "announcement"
    t.string "cover_url"
    t.text "body"
    t.string "link"
    t.datetime "published_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "heading_id"
    t.index ["heading_id"], name: "index_materials_on_heading_id"
    t.index ["link"], name: "index_materials_on_link"
    t.index ["published_date"], name: "index_materials_on_published_date"
  end

  create_table "materials_tags", force: :cascade do |t|
    t.integer "material_id"
    t.integer "tag_id"
    t.index ["material_id"], name: "index_materials_tags_on_material_id"
    t.index ["tag_id"], name: "index_materials_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_tags_on_slug"
    t.index ["title"], name: "index_tags_on_title"
  end

  create_table "users", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_users_on_token"
  end

end
