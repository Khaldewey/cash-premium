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

ActiveRecord::Schema.define(version: 2024_07_28_200349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analytics", force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banner_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.integer "image_width"
    t.integer "image_height"
    t.index ["is_active"], name: "index_banner_categories_on_is_active"
    t.index ["name"], name: "index_banner_categories_on_name", unique: true
  end

  create_table "banners", force: :cascade do |t|
    t.string "image"
    t.string "link"
    t.bigint "banner_category_id"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.datetime "published_at"
    t.index ["banner_category_id"], name: "index_banners_on_banner_category_id"
    t.index ["expires_at"], name: "index_banners_on_expires_at"
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.integer "assetable_id"
    t.string "assetable_type", limit: 30
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
    t.index ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"
  end

  create_table "failures", force: :cascade do |t|
    t.bigint "payment_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_failures_on_member_id"
    t.index ["payment_id"], name: "index_failures_on_payment_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "lotteries", force: :cascade do |t|
    t.string "event"
    t.datetime "date_event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ticket"
    t.boolean "status"
    t.integer "result"
    t.float "price"
    t.string "winner"
    t.string "image"
    t.string "content"
    t.integer "number_winner"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "tickets", default: {}
    t.bigint "lottery_id"
    t.string "cpf"
    t.index ["cpf"], name: "index_members_on_cpf", unique: true
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["lottery_id"], name: "index_members_on_lottery_id"
    t.index ["phone"], name: "index_members_on_phone", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "paragraphs", force: :cascade do |t|
    t.text "content"
    t.string "image"
    t.string "videoparagrafo"
    t.string "youtube_video_id"
    t.string "paragraphable_type"
    t.bigint "paragraphable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paragraphable_id", "paragraphable_type"], name: "index_paragraphs_on_paragraphable_id_and_paragraphable_type"
    t.index ["paragraphable_type", "paragraphable_id"], name: "index_paragraphs_on_paragraphable_type_and_paragraphable_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "transaction_id"
    t.bigint "lottery_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity"
    t.index ["lottery_id"], name: "index_payments_on_lottery_id"
    t.index ["member_id"], name: "index_payments_on_member_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "description"
    t.string "object_type"
    t.string "action_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_type", "action_name"], name: "index_permissions_on_object_type_and_action_name", unique: true
  end

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.bigint "permission_id"
    t.bigint "role_id"
    t.index ["permission_id", "role_id"], name: "index_permissions_roles_on_permission_id_and_role_id", unique: true
    t.index ["permission_id"], name: "index_permissions_roles_on_permission_id"
    t.index ["role_id"], name: "index_permissions_roles_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "social_networks", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "status"
    t.integer "quantity"
    t.bigint "transaction_id"
    t.bigint "lottery_id"
    t.bigint "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expiration_time"
    t.index ["lottery_id"], name: "index_transactions_on_lottery_id"
    t.index ["member_id"], name: "index_transactions_on_member_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.bigint "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_active", default: true
    t.boolean "is_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["is_admin"], name: "index_users_on_is_admin"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "banners", "banner_categories"
  add_foreign_key "failures", "members"
  add_foreign_key "failures", "payments"
  add_foreign_key "members", "lotteries"
  add_foreign_key "payments", "lotteries"
  add_foreign_key "payments", "members"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "transactions", "lotteries"
  add_foreign_key "transactions", "members"
  add_foreign_key "users", "roles"
end
