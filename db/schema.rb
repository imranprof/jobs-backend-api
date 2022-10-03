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

ActiveRecord::Schema.define(version: 2022_10_03_101533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_1", null: false
    t.string "address_2", null: false
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip_code", null: false
    t.string "country", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "reading_time", null: false
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categorizations", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "categorizable_type", null: false
    t.bigint "categorizable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["categorizable_type", "categorizable_id"], name: "index_categorizations_on_categorizable"
    t.index ["category_id"], name: "index_categorizations_on_category_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "education_histories", force: :cascade do |t|
    t.string "institution", null: false
    t.string "degree", null: false
    t.string "grade", null: false
    t.text "description", null: false
    t.datetime "start_date", precision: 6, null: false
    t.datetime "end_date", precision: 6, null: false
    t.boolean "currently_enrolled", null: false
    t.boolean "visibility", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_education_histories_on_user_id"
  end

  create_table "expertises", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_profile_id", null: false
    t.index ["user_profile_id"], name: "index_expertises_on_user_profile_id"
  end

  create_table "features", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_features_on_user_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "selection"
    t.text "cover_letter", null: false
    t.integer "bid_rate"
    t.boolean "hire"
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.string "location"
    t.string "skills", default: [], array: true
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pay_type"
    t.integer "budget", default: [], array: true
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.integer "sender_id", null: false
    t.integer "recipient_id", null: false
    t.integer "parent_message_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "has_read", default: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "live_url", null: false
    t.string "source_url", null: false
    t.integer "react_count", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "reviewer_name", null: false
    t.string "reviewer_designation", null: false
    t.text "description", null: false
    t.string "reviewer_profile_url", null: false
    t.boolean "visibility", null: false
    t.decimal "rating", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "custom_skill", default: false, null: false
  end

  create_table "social_links", force: :cascade do |t|
    t.string "facebook"
    t.string "github"
    t.string "linkedin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_profile_id", null: false
    t.index ["user_profile_id"], name: "index_social_links_on_user_profile_id"
  end

  create_table "user_contacts", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone_number", null: false
    t.string "email", null: false
    t.text "message", null: false
    t.integer "user_id", null: false
    t.integer "messenger_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "subject"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.text "headline", null: false
    t.string "title", null: false
    t.text "bio", null: false
    t.string "identity_number", null: false
    t.integer "gender", null: false
    t.integer "religion", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "designation", default: "", null: false
    t.text "contact_info", default: "", null: false
    t.string "contact_email"
    t.string "expertises", default: [], array: true
    t.string "slug"
    t.integer "hourly_rate"
    t.index ["slug"], name: "index_user_profiles_on_slug", unique: true
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "role", default: "employee", null: false
    t.string "company_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["token"], name: "index_users_on_token"
  end

  create_table "users_skills", force: :cascade do |t|
    t.integer "rating"
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["skill_id"], name: "index_users_skills_on_skill_id"
    t.index ["user_id"], name: "index_users_skills_on_user_id"
  end

  create_table "work_histories", force: :cascade do |t|
    t.string "title", null: false
    t.integer "employment_type", null: false
    t.string "company_name", null: false
    t.text "description", null: false
    t.datetime "start_date", precision: 6, null: false
    t.datetime "end_date", precision: 6, null: false
    t.boolean "currently_employed", null: false
    t.boolean "visibility", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_work_histories_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blogs", "users"
  add_foreign_key "categorizations", "categories"
  add_foreign_key "education_histories", "users"
  add_foreign_key "expertises", "user_profiles"
  add_foreign_key "features", "users"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "users"
  add_foreign_key "jobs", "users"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "projects", "users"
  add_foreign_key "social_links", "user_profiles"
  add_foreign_key "user_contacts", "users"
  add_foreign_key "user_contacts", "users", column: "messenger_id"
  add_foreign_key "user_profiles", "users"
  add_foreign_key "users_skills", "skills"
  add_foreign_key "users_skills", "users"
  add_foreign_key "work_histories", "users"
end
