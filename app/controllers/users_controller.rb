class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :api

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def api
    @user = User.where(:access_tokens => {"$elemMatch" => {:value => params[:access_token]}}).first
    render :json => {
      :name => @user.username,
      :email => @user.email,
    }.to_json
  end

end
