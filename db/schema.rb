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

ActiveRecord::Schema.define(version: 20131226232017) do

  create_table "admins", force: true do |t|
    t.integer "user_id"
  end

  create_table "answers", force: true do |t|
    t.integer  "call_survey_id"
    t.integer  "question_id"
    t.integer  "option_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["call_survey_id"], name: "index_answers_on_call_survey_id", using: :btree
  add_index "answers", ["option_id"], name: "index_answers_on_option_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "call_scripts", force: true do |t|
    t.string "call_sid"
    t.string "next_action"
    t.text   "params"
  end

  add_index "call_scripts", ["call_sid"], name: "index_call_scripts_on_call_sid", using: :btree

  create_table "call_surveys", force: true do |t|
    t.integer  "call_id"
    t.integer  "survey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "call_surveys", ["call_id"], name: "index_call_surveys_on_call_id", using: :btree
  add_index "call_surveys", ["survey_id"], name: "index_call_surveys_on_survey_id", using: :btree

  create_table "callbacks", force: true do |t|
    t.integer  "psychic_id"
    t.integer  "client_id"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",           default: "active"
    t.string   "client_call_sid"
    t.string   "psychic_call_sid"
  end

  add_index "callbacks", ["client_id"], name: "index_callbacks_on_client_id", using: :btree
  add_index "callbacks", ["psychic_id"], name: "index_callbacks_on_psychic_id", using: :btree

  create_table "calls", force: true do |t|
    t.integer  "client_id"
    t.string   "sid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "processed"
    t.string   "parent_call_sid"
    t.string   "date_created"
    t.string   "date_updated"
    t.string   "account_sid"
    t.string   "to"
    t.string   "from"
    t.string   "phone_number_sid"
    t.string   "status"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "original_duration"
    t.string   "price"
    t.string   "price_unit"
    t.string   "direction"
    t.string   "answered_by"
    t.string   "caller_name"
    t.string   "uri"
    t.integer  "duration"
    t.integer  "psychic_id"
    t.decimal  "cost",              precision: 8, scale: 2
    t.decimal  "cost_per_minute",   precision: 8, scale: 2
    t.integer  "invoice_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.decimal  "rate",              precision: 8, scale: 2
  end

  add_index "calls", ["client_id"], name: "index_calls_on_client_id", using: :btree
  add_index "calls", ["invoice_id"], name: "index_calls_on_invoice_id", using: :btree
  add_index "calls", ["psychic_id"], name: "index_calls_on_psychic_id", using: :btree
  add_index "calls", ["sid"], name: "index_calls_on_sid", using: :btree

  create_table "cards", force: true do |t|
    t.integer  "client_id"
    t.string   "last4"
    t.string   "type"
    t.integer  "exp_month"
    t.integer  "exp_year"
    t.string   "country"
    t.string   "address_city"
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cards", ["client_id"], name: "index_cards_on_client_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "client_phones", force: true do |t|
    t.integer  "client_id"
    t.string   "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "desc"
  end

  add_index "client_phones", ["client_id"], name: "index_client_phones_on_client_id", using: :btree
  add_index "client_phones", ["number"], name: "index_client_phones_on_number", unique: true, using: :btree

  create_table "clients", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "balance",             precision: 8, scale: 2
    t.string   "stripe_client_id"
    t.string   "pin"
    t.boolean  "receive_newsletters",                         default: true
    t.string   "unsubscribe_key"
    t.string   "avatar_id"
    t.date     "birthday"
    t.boolean  "disabled",                                    default: false
  end

  add_index "clients", ["user_id"], name: "index_clients_on_user_id", using: :btree

  create_table "clients_psychics", id: false, force: true do |t|
    t.integer "client_id"
    t.integer "psychic_id"
  end

  add_index "clients_psychics", ["client_id", "psychic_id"], name: "index_clients_psychics_on_client_id_and_psychic_id", using: :btree

  create_table "credits", force: true do |t|
    t.integer  "client_id"
    t.decimal  "credits",     precision: 8, scale: 2
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "refunded"
  end

  add_index "credits", ["client_id"], name: "index_credits_on_client_id", using: :btree
  add_index "credits", ["target_id", "target_type"], name: "index_credits_on_target_id_and_target_type", using: :btree

  create_table "customer_service_representatives", force: true do |t|
    t.integer  "user_id"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available"
  end

  add_index "customer_service_representatives", ["user_id"], name: "index_customer_service_representatives_on_user_id", using: :btree

  create_table "daily_fortunes", force: true do |t|
    t.date     "start_date", null: false
    t.date     "end_date",   null: false
    t.string   "sunday",     null: false
    t.string   "monday",     null: false
    t.string   "tuesday",    null: false
    t.string   "wednesday",  null: false
    t.string   "thursday",   null: false
    t.string   "friday",     null: false
    t.string   "saturday",   null: false
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faqs", force: true do |t|
    t.text     "question"
    t.text     "answer"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "faqs", ["category_id"], name: "index_faqs_on_category_id", using: :btree

  create_table "horoscopes", force: true do |t|
    t.date     "date"
    t.text     "aries"
    t.text     "taurus"
    t.text     "gemini"
    t.text     "cancer"
    t.text     "leo"
    t.text     "virgo"
    t.text     "libra"
    t.text     "scorpio"
    t.text     "sagittarius"
    t.text     "capricorn"
    t.text     "aquarius"
    t.text     "pisces"
    t.text     "lovescope"
    t.string   "friendship_compatibility_from"
    t.string   "love_compatibility_from"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friendship_compatibility_to"
    t.string   "love_compatibility_to"
  end

  create_table "hours", force: true do |t|
    t.integer  "psychic_id"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "call_id"
  end

  add_index "hours", ["call_id"], name: "index_hours_on_call_id", using: :btree
  add_index "hours", ["psychic_id"], name: "index_hours_on_psychic_id", using: :btree

  create_table "invoices", force: true do |t|
    t.integer  "psychic_id"
    t.integer  "total_minutes"
    t.integer  "number_of_calls"
    t.decimal  "avg_minutes",     precision: 8, scale: 2
    t.decimal  "minutes_payout",  precision: 8, scale: 2
    t.decimal  "bonus_payout",    precision: 8, scale: 2
    t.integer  "tier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bonus_minutes"
    t.decimal  "total",           precision: 8, scale: 2
    t.datetime "paid_at"
    t.date     "start_date"
    t.date     "end_date"
  end

  add_index "invoices", ["psychic_id"], name: "index_invoices_on_psychic_id", using: :btree
  add_index "invoices", ["tier_id"], name: "index_invoices_on_tier_id", using: :btree

  create_table "newsletters", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "deliver_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivered_at"
  end

  create_table "options", force: true do |t|
    t.integer  "question_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "options", ["question_id"], name: "index_options_on_question_id", using: :btree

  create_table "order_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "package_id"
    t.string   "description"
    t.integer  "qty"
    t.decimal  "unit_price",  precision: 8, scale: 2
    t.decimal  "total_price", precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["package_id"], name: "index_order_items_on_package_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "client_id"
    t.decimal  "total",          precision: 8, scale: 2
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_method"
  end

  add_index "orders", ["client_id"], name: "index_orders_on_client_id", using: :btree

  create_table "packages", force: true do |t|
    t.string   "name"
    t.decimal  "credits",    precision: 8, scale: 2
    t.decimal  "price",      precision: 8, scale: 2
    t.boolean  "active",                             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "phone"
  end

  create_table "page_seos", force: true do |t|
    t.string   "page"
    t.string   "url"
    t.string   "title"
    t.text     "description"
    t.text     "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_seos", ["url"], name: "index_page_seos_on_url", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "invoice_id"
    t.string   "transaction_id"
    t.decimal  "amount",         precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["invoice_id"], name: "index_payments_on_invoice_id", using: :btree

  create_table "psychic_applications", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "cellular_number"
    t.date     "date_of_birth"
    t.string   "emergency_contact"
    t.string   "emergency_contact_number"
    t.boolean  "us_citizen"
    t.boolean  "has_experience"
    t.text     "experience"
    t.string   "gift"
    t.text     "explain_gift"
    t.integer  "age_discovered"
    t.text     "reading_style"
    t.text     "why_work"
    t.text     "friends_describe"
    t.text     "strongest_weakest_attributes"
    t.text     "how_to_deal_challenging_client"
    t.text     "specialties"
    t.text     "tools"
    t.text     "professional_goals"
    t.string   "how_did_you_hear"
    t.text     "other"
    t.datetime "approved_at"
    t.integer  "psychic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resume"
    t.datetime "declined_at"
    t.string   "phone"
    t.boolean  "terms"
    t.string   "pseudonym"
    t.string   "country"
    t.decimal  "price",                          precision: 8, scale: 2
    t.string   "time_zone",                                              null: false
  end

  create_table "psychic_events", force: true do |t|
    t.integer  "psychic_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "psychic_events", ["psychic_id"], name: "index_psychic_events_on_psychic_id", using: :btree

  create_table "psychic_faq_categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "psychic_faqs", force: true do |t|
    t.integer  "psychic_faq_category_id"
    t.text     "question",                null: false
    t.text     "answer",                  null: false
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "psychic_faqs", ["psychic_faq_category_id"], name: "index_psychic_faqs_on_psychic_faq_category_id", using: :btree

  create_table "psychic_training_items", force: true do |t|
    t.integer  "psychic_id"
    t.integer  "training_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "psychic_training_items", ["psychic_id"], name: "index_psychic_training_items_on_psychic_id", using: :btree
  add_index "psychic_training_items", ["training_item_id"], name: "index_psychic_training_items_on_training_item_id", using: :btree

  create_table "psychics", force: true do |t|
    t.integer  "user_id"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "cellular_number"
    t.string   "ssn"
    t.date     "date_of_birth"
    t.string   "emergency_contact"
    t.string   "emergency_contact_number"
    t.boolean  "us_citizen"
    t.boolean  "has_experience"
    t.text     "experience"
    t.string   "gift"
    t.text     "explain_gift"
    t.integer  "age_discovered"
    t.text     "reading_style"
    t.text     "why_work"
    t.text     "friends_describe"
    t.text     "strongest_weakest_attributes"
    t.text     "how_to_deal_challenging_client"
    t.text     "tools"
    t.text     "specialties"
    t.text     "professional_goals"
    t.string   "how_did_you_hear"
    t.text     "other"
    t.string   "resume"
    t.boolean  "featured"
    t.boolean  "ability_clairvoyance"
    t.boolean  "ability_clairaudient"
    t.boolean  "ability_clairsentient"
    t.boolean  "ability_empathy"
    t.boolean  "ability_medium"
    t.boolean  "ability_channeler"
    t.boolean  "ability_dream_analysis"
    t.boolean  "tools_tarot"
    t.boolean  "tools_oracle_cards"
    t.boolean  "tools_runes"
    t.boolean  "tools_crystals"
    t.boolean  "tools_pendulum"
    t.boolean  "tools_numerology"
    t.boolean  "tools_astrology"
    t.boolean  "specialties_love_and_relationships"
    t.boolean  "specialties_career_and_work"
    t.boolean  "specialties_money_and_finance"
    t.boolean  "specialties_lost_objects"
    t.boolean  "specialties_dream_interpretation"
    t.boolean  "specialties_pet_and_animals"
    t.boolean  "specialties_past_lives"
    t.boolean  "specialties_deceased"
    t.boolean  "style_compassionate"
    t.boolean  "style_inspirational"
    t.boolean  "style_straightforward"
    t.text     "about"
    t.decimal  "price",                              precision: 8, scale: 2
    t.string   "pseudonym"
    t.string   "country"
    t.string   "avatar_id"
    t.string   "top_speciality"
    t.string   "status",                                                     default: "unavailable", null: false
    t.boolean  "disabled"
  end

  add_index "psychics", ["extension"], name: "index_psychics_on_extension", unique: true, using: :btree
  add_index "psychics", ["user_id"], name: "index_psychics_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "survey_id"
    t.string   "type"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["id", "type"], name: "index_questions_on_id_and_type", using: :btree
  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "psychic_id"
    t.integer  "client_id"
    t.integer  "rating"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "featured",   default: false
    t.integer  "call_id"
  end

  add_index "reviews", ["call_id"], name: "index_reviews_on_call_id", using: :btree
  add_index "reviews", ["client_id"], name: "index_reviews_on_client_id", using: :btree
  add_index "reviews", ["psychic_id"], name: "index_reviews_on_psychic_id", using: :btree

  create_table "schedule_jobs", force: true do |t|
    t.string   "description", null: false
    t.string   "week_day",    null: false
    t.string   "at",          null: false
    t.string   "model",       null: false
    t.string   "action",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.integer  "psychic_id"
    t.date     "date"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  add_index "schedules", ["date"], name: "index_schedules_on_date", using: :btree
  add_index "schedules", ["psychic_id", "date"], name: "index_schedules_on_psychic_id_and_date", using: :btree

  create_table "subscribers", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tiers", force: true do |t|
    t.string   "name"
    t.integer  "from"
    t.integer  "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "percent",    precision: 8, scale: 2
  end

  create_table "training_items", force: true do |t|
    t.string   "title"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.integer  "order_id"
    t.string   "operation"
    t.string   "transaction_id"
    t.boolean  "success"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.decimal  "amount",         precision: 8, scale: 2
    t.string   "card"
  end

  add_index "transactions", ["client_id"], name: "index_transactions_on_client_id", using: :btree
  add_index "transactions", ["order_id"], name: "index_transactions_on_order_id", using: :btree
  add_index "transactions", ["transaction_id"], name: "index_transactions_on_transaction_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "role"
    t.string   "provider"
    t.string   "uid"
    t.string   "time_zone",                           null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "faqs", "categories", name: "faqs_category_id_fk"

  add_foreign_key "psychic_faqs", "psychic_faq_categories", name: "psychic_faqs_psychic_faq_category_id_fk"

end
