class SubscriptionsController < ApplicationController
  before_action :signed_in_user
  
  def create
    @user = User.find(params[:subscription][:author_id])
    current_user.follow! @user
    redirect_to @user
  end
  
  def destroy
    @user = Subscription.find(params[:id]).author
    current_user.unfollow! @user
    redirect_to @user
  end
end
