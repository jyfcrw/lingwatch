class CreateDialogueMessages < ActiveRecord::Migration
  def change
    create_table :dialogue_messages do |t|
      t.belongs_to :device
      t.belongs_to :dialogue
      t.string   "device_code", index: true
      t.string   "dialogue_code"
      t.string   "phone", index: true
      t.string   "topic"
      t.string   "content"
      t.datetime "created_at"
    end
  end
end
