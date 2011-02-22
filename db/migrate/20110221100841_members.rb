class Members < ActiveRecord::Migration
  def self.up
  end

  def self.up
    create_table :members do |t|
      t.string :name
      t.boolean :is_broadcaster
      t.integer :open_tok_session_id
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
