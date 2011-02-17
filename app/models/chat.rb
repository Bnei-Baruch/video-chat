class Chat < ActiveRecord::Base
  def self.cleanup(room = nil)
    return if room.nil?
    Chat.where(:room => room).delete_all
  end
end