class ChatsController < ApplicationController
  def show
    start_from = params[:start] || 0
    room = params[:chat_room] || params[:id]
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

end
