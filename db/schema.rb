# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_23_160923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "start_date", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["start_date"], name: "index_conversations_on_start_date"
    t.index ["title"], name: "index_conversations_on_title_trigram", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "date_time_sent", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["date_time_sent"], name: "index_messages_on_date_time_sent"
    t.index ["text"], name: "index_messages_on_text_trigram", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "thoughts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date_time_sent", null: false
    t.bigint "message_id", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.index ["date_time_sent"], name: "index_thoughts_on_date_time_sent"
    t.index ["message_id"], name: "index_thoughts_on_message_id"
  end

  add_foreign_key "messages", "conversations", on_delete: :cascade
  add_foreign_key "thoughts", "messages", on_delete: :cascade
end
