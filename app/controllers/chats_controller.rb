class ChatsController < ApplicationController
  def show
    start_from = params[:start] || 0
    room = params[:chat_room] || params[:id]
    member = Member.find(params[:member_id])
    if member
      member.updated_at= DateTime.now
      member.save!
    end
    Member.cleanup
    
    sql = Chat.where(:room => room).where(:id.gt => start_from)
    if start_from == 0
      # Just 10 last messages
      messages = sql.order('created_at DESC').limit(10)
    else
      # All messages starting from 'start_from''
      messages = sql.order('created_at').limit(10)
    end

    render :text => messages.all.to_json, :status => messages.empty? ? 302 : 200
  end

  def create
    chat = Chat.new(params[:chat])
    chat.save
    render :text => ''
  end

  def members
    # Update list of members in chat
    session = OpenTokSession.find(params[:id])
    render :json => session.members.map{|m| "#{m.name} #{m.is_broadcaster ? ' (b)' : ' (g)'}"}.to_json
  end
end
