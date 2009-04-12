class UsersController < ApplicationController
  def index
    @users = User.all
  end
  def show
    @user = User.find(params[:id])
  end
  def followed_search
    @user = User.find(params[:id])
    @relevant_tweets = @user.relevant_tweets
  end
end
