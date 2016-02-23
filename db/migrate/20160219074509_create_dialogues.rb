class CreateDialogues < ActiveRecord::Migration
  def change
    create_table :dialogues do |t|
      t.belongs_to :device
      t.string   "code", index: true, unique: true
      t.string   "state"
      t.hstore   "setting"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table :dialogue_accessions do |t|
      t.belongs_to :dialogue
      t.belongs_to :device
      t.string   "action"
      t.datetime "created_at"
    end
  end
end
