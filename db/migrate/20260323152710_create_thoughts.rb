class CreateThoughts < ActiveRecord::Migration[8.0]
  def change
    create_table :thoughts do |t|
      t.text :text, null: false
      t.datetime :date_time_sent, null: false
      t.references :message, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :thoughts, :date_time_sent
  end
end
