require 'lib/opentok'

class OpenTokSession < ActiveRecord::Base
  @@api_key    = 277241
  @@api_secret = "cb11d5cbd9de98fd547861daa13d03e985731454"
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