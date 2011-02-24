class ClientController < ApplicationController
  layout 'session'

  def authenticate
    if params[:user_id]
      user = Member.find(params[:user_id])
      auth = Pusher[params[:channel_name]].authenticate(params[:socket_id],
                                                        :user_id => user.id,
                                                        :chat_user => user.attributes
      )
      render :json => auth
    else
      render :text => "Not authorized", :status => '403'
    end
  end

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
    @member = Member.new(:name => params[:name], :is_broadcaster => @broadcaster)
    @member.open_tok_session = @session
    @member.save!
    @chat = Chat.new(:room => @session.id, :name => @member.name)
    @members = @session.members
    render :show
  end
end
