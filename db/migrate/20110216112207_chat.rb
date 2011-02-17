class Chat < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.integer :room
      t.text :message
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :chats
  end
end
