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

ActiveRecord::Schema.define(version: 2024_05_27_125711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analytics", force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "article_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.string "slug"
    t.index ["is_active"], name: "index_article_categories_on_is_active"
    t.index ["name"], name: "index_article_categories_on_name", unique: true
    t.index ["slug"], name: "index_article_categories_on_slug", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "abstract"
    t.text "content"
    t.datetime "published_at"
    t.bigint "article_category_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_category_id"], name: "index_articles_on_article_category_id"
    t.index ["slug"], name: "index_articles_on_slug", unique: true
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

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.string "abstract"
    t.text "content"
    t.string "image"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "email_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_contacts", force: :cascade do |t|
    t.string "email"
    t.bigint "email_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_category_id"], name: "index_email_contacts_on_email_category_id"
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

  create_table "images", force: :cascade do |t|
    t.string "image"
    t.string "title"
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "localizations", force: :cascade do |t|
    t.string "link"
    t.text "address"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lotteries", force: :cascade do |t|
    t.string "event"
    t.datetime "date_event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.integer "ticket"
    t.integer "result"
  end

  create_table "members", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "phone"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lottery_id"
    t.jsonb "tickets", default: {}
    t.string "qr_code_url"
    t.index ["email"], name: "index_members_on_email", unique: true
    t.index ["lottery_id"], name: "index_members_on_lottery_id"
    t.index ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "name", default: ""
    t.string "email", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_newsletters_on_email", unique: true
    t.index ["name"], name: "index_newsletters_on_name"
  end

  create_table "notice_categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notices", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "abstract"
    t.text "content"
    t.datetime "published_at"
    t.string "cover_image"
    t.boolean "cover_image_body"
    t.string "content_audio"
    t.string "audio"
    t.string "subtitle_cover_image"
    t.boolean "is_highlight"
    t.boolean "is_active", default: false
    t.string "video_url"
    t.string "youtube_video_id"
    t.bigint "notice_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.index ["notice_category_id"], name: "index_notices_on_notice_category_id"
  end

  create_table "page_images", force: :cascade do |t|
    t.string "image"
    t.string "title"
    t.integer "position"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_images_on_page_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title"
    t.string "abstract"
    t.text "content"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_pages_on_slug", unique: true
    t.index ["title"], name: "index_pages_on_title", unique: true
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

  create_table "phones", force: :cascade do |t|
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "tutorials", force: :cascade do |t|
    t.string "title"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "youtube_video_id"
  end

  add_foreign_key "articles", "article_categories"
  add_foreign_key "banners", "banner_categories"
  add_foreign_key "email_contacts", "email_categories"
  add_foreign_key "members", "lotteries"
  add_foreign_key "notices", "notice_categories"
  add_foreign_key "page_images", "pages"
  add_foreign_key "permissions_roles", "permissions"
  add_foreign_key "permissions_roles", "roles"
  add_foreign_key "users", "roles"
end
