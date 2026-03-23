class AddTrigramIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :conversations, :title, using: :gin, opclass: :gin_trgm_ops,
              name: "index_conversations_on_title_trigram"
    add_index :messages, :text, using: :gin, opclass: :gin_trgm_ops,
              name: "index_messages_on_text_trigram"
  end
end
