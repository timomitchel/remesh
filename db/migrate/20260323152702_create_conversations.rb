class CreateConversations < ActiveRecord::Migration[8.0]
  def change
    create_table :conversations do |t|
      t.string :title, null: false
      t.date :start_date, null: false

      t.timestamps
    end
  end
end
