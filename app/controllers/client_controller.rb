class ClientController < ApplicationController
  layout 'session'

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
    @path = broadcaster ? :broadcaster_show_client_index : :guest_show_client_index
    render :index
  end

  def show_session(broadcaster = false)
    if params[:name].nil? || params[:name].empty?
      render :js => 'alert("Please enter your Name");'
      return
    end
    if params[:room].nil? || params[:room].empty?
      render :js => 'alert("Please select Room");'
      return
    end
    @broadcaster = broadcaster
    @session, @token, @api_key = OpenTokSession.generate_token(params[:room])
    @name = params[:name]
    @chat = Chat.new(:room => @session.id, :name => @name)
    render :show
  end
end
