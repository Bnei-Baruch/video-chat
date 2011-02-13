class CreateOpentok < ActiveRecord::Migration
  def self.up
    create_table :open_tok_sessions do |t|
      t.string :session_title
      t.string :location, :default => '127.0.0.1' # localhost
      t.boolean :echo_suppression, :default => false # no echo suppression
      t.boolean :multiplexer, :default => false # no multiplexing
      t.integer :output_streams
      t.integer :switch_type, :default => 0 # 0 - timeout based; 1 - activity-based
      t.integer :switch_timeout, :default => 5000 # 5 sec
      t.string :session_id

      t.timestamps
    end
  end

  def self.down
    drop_table :open_tok_sessions
  end
end
