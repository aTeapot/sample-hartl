class SubscriptionsController < ApplicationController
  before_action :signed_in_user
  
  respond_to :html, :js
  
  def create
    @user = User.find(params[:subscription][:author_id])
    current_user.follow! @user
    respond_with @user
  end
  
  def destroy
    @user = Subscription.find(params[:id]).author
    current_user.unfollow! @user
    respond_with @user
  end
end
