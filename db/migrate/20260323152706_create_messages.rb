class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.text :text, null: false
      t.datetime :date_time_sent, null: false
      t.references :conversation, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :messages, :date_time_sent
  end
end
