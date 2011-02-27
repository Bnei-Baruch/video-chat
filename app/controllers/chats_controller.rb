require 'pusher'

if Rails.env == 'Development'
  Pusher.app_id = '4130'
  Pusher.key = '36cf16622b9fbe32f9cf'
  Pusher.secret = '91d45c8f5f79429e44ef'
else
  Pusher.app_id = '4132'
  Pusher.key = '46ee62dcbfe82eb253a9'
  Pusher.secret = 'a6e1db500dd165c6c925'
end

class ChatsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  
  def show
    room = params[:chat_room] || params[:id]

    # Cleanup members
    if params[:member_id]
      member = Member.find(params[:member_id])
      if member
        member.updated_at= DateTime.now
        member.save!
      end
      Member.cleanup
    end

    messages = Chat.where(:room => room).order('created_at DESC').limit(10).all.reverse

    render :text => messages.to_json, :status => messages.empty? ? 302 : 200
  end

  def create
    chat = Chat.new(params[:chat])
    message = sanitize chat.message

    if message.empty?
      render :text => ''
      return
    end
    message = message.gsub(/(http:\/\/\S+|www.\S+)/i, "<a href='\\1' target='_blank'>\\1</a>");
    chat.message = message

    if chat.save
      Pusher["channel-#{chat.room}"].trigger('new_message_event', chat.attributes)
    end
    # Cleanup members
    if params[:member_id]
      member = Member.find(params[:member_id])
      if member
        member.updated_at= DateTime.now
        member.save!
      end
      Member.cleanup
    end

    render :text => ''
  end

  def members
    # Update list of members in chat
    session = OpenTokSession.find(params[:id])
    render :json => session.members.map { |m| "#{m.name} #{m.is_broadcaster ? ' (host)' : ' (guest)'}" }.to_json
  end
end
