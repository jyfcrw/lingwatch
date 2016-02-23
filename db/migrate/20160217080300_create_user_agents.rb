class CreateUserAgents < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.belongs_to  "user"
      t.string   "uid",  index: true, unique: true
      t.string   "code", index: true
      t.string   "secret"
      t.string   "os_type"
      t.string   "state"
      t.hstore   "setting"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    change_table :devices do |t|
      t.string   "uid",  index: true, unique: true
    end
  end
end
