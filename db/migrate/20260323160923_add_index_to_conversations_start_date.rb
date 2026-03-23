class AddIndexToConversationsStartDate < ActiveRecord::Migration[8.1]
  def change
    add_index :conversations, :start_date
  end
end
