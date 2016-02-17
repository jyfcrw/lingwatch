class CreateDevices < ActiveRecord::Migration
  def change
    reversible do |change|
      change.up do
        enable_extension :hstore
      end

      change.down do
        disable_extension :hstore
      end
    end

    create_table :devices do |t|
      t.string   "code", index: true, unique: true
      t.string   "secret"
      t.string   "model_type"
      t.string   "name"
      t.string   "poster"
      t.string   "mac"
      t.string   "state"
      t.hstore   "setting"
      t.string   "type", null: false
      t.datetime "activated_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :device_bindings do |t|
      t.integer  :user_id
      t.integer  :device_id
      t.string   :device_type

      t.timestamps
    end

    add_index :device_bindings, [:user_id]
    add_index :device_bindings, [:device_type, :device_id]
  end
end
