class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   "name"
      t.string   "phone"
      t.string   "avatar"
      t.string   "unconfirmed_phone"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "extra"
      t.datetime "sms_confirmed_at"
      t.string   "crypted_password"
      t.string   "password_salt"
      t.string   "persistence_token"
      t.string   "single_access_token"
      t.string   "perishable_token"
      t.integer  "login_count",         default: 0,    null: false
      t.integer  "failed_login_count",  default: 0,    null: false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.boolean  "active",              default: true
    end

    add_index "users", ["persistence_token"], name: "index_users_on_persistence_token", unique: true, using: :btree
    add_index "users", ["phone"], name: "index_users_on_phone", unique: true, using: :btree
  end
end
