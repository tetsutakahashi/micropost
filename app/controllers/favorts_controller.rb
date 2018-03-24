class FavortsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    flash[:success] = 'micropostをお気に入りに追加しました。'
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == 'toppages' && path[:action] == 'index'
      redirect_to root_url
    elsif path[:controller] == 'users' && path[:action] == 'show'
      @user = User.find(micropost.user)
      redirect_to @user
    end
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unfavorite(micropost)
    flash[:success] = 'micropostをお気に入りから解除しました。'
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == 'toppages' && path[:action] == 'index'
      redirect_to root_url
    elsif path[:controller] == 'users' && path[:action] == 'show'
      @user = User.find(micropost.user)
      redirect_to @user
    else
      redirect_to myfavorites_user_url(current_user)
    end
  end
  
end