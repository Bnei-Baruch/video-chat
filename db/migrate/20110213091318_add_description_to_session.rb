class AddDescriptionToSession < ActiveRecord::Migration
  def self.up
    add_column :open_tok_sessions, :description, :text, :default => ''
  end

  def self.down
    remove_column :open_tok_sessions, :description
  end
end
