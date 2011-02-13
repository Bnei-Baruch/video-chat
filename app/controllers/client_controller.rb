class ClientController < ApplicationController

  # List of sessions
  def index
    @sessions = OpenTokSession.all
  end

  # Show me in specific session
  def show
    @session, @token, @api_key = OpenTokSession.generate_token(params[:id])
  end
end
