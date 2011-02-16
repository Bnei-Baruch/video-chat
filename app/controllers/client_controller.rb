class ClientController < ApplicationController

  # List of sessions
  def index
    all_sessions
  end

  def broadcaster
    all_sessions true
  end

  def guest
    all_sessions
  end

  # Show me in specific session
  def broadcaster_show
    show_session true
  end

  def guest_show
    show_session
  end

  def show
    show_session
  end

  private
  def all_sessions(broadcaster = false)
    @broadcaster = broadcaster
    @sessions = OpenTokSession.all
    @path = broadcaster ? :broadcaster_show_client_path : :guest_show_client_path
    render :index
  end

  def show_session(broadcaster = false)
    @broadcaster = broadcaster
    @session, @token, @api_key = OpenTokSession.generate_token(params[:id])
    render :show
  end
end
