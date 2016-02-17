class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string   "email",                default: "",    null: false
      t.string   "crypted_password",     default: "",    null: false
      t.integer  "login_count",          default: 0,     null: false
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "password_salt"
      t.string   "persistence_token",                    null: false
      t.integer  "failed_login_count",   default: 0,     null: false
      t.text     "extra"
    end

    add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
    add_index "admins", ["persistence_token"], name: "index_admins_on_persistence_token", unique: true, using: :btree
  end
end
