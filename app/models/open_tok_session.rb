require 'lib/opentok'

class OpenTokSession < ActiveRecord::Base
  @@api_key    = ENV['VIDEO_CHAT_API_KEY']
  @@api_secret = ENV['VIDEO_CHAT_API_SECRET']
  @@api = OpenTok::OpenTokSDK.new @@api_key, @@api_secret

  validate :session_title, :presence => true, :uniqueness => true, :length => {:minimum => 1}
  validate :location, :presence => true

  has_many :members
  
  def create_session!
    session = @@api.create_session self.location
    self.session_id = session.session_id
  end

  def self.generate_token(id)
    session = find(id)
    token = @@api.generate_token :session_id => session.session_id
    [session, token, @@api_key]
  end

end