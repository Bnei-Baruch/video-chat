class Admin::OpenTokSessionController < ApplicationController

  respond_to :html, :js

#  before_filter :check_if_restricted
  layout 'admin_pages'

  # Display all sessions
  def index
    @sessions = OpenTokSession.order(:id).all
  end

  def new
    @session = OpenTokSession.new
  end

  def create
    @session = OpenTokSession.new(params[:open_tok_session])
    @session.create_session!

    if @session.save
      flash[:notice] = I18n.t 'admin.sessions.success'
      redirect_to :action => :index
      return
    else
      flash[:alert] = I18n.t 'admin.sessions.error'
    end
  end

  def edit
    @session = OpenTokSession.find(params[:id])
  end

  def update
    @session = OpenTokSession.find(params[:id])

    if @session.update_attribute(:session_title, params[:open_tok_session][:session_title]) &&
        @session.update_attribute(:description, params[:open_tok_session][:description])
      flash[:notice] = I18n.t 'admin.pages.update'
    end

    redirect_to :action => :index
  end

  def destroy
    begin
      @session = OpenTokSession.find(params[:id])
      @session.destroy
      flash[:notice] = I18n.t 'admin.sessions.success'
    rescue
      flash[:alert] = I18n.t 'admin.sessions.error'
    end
    redirect_to :action => :index
  end
end
