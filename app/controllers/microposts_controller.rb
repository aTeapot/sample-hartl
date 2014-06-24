class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    respond_to do |format|
      if @micropost.save
        format.html { redirect_to root_path }
      else
        @feed_items = []
        format.html { render 'static_pages/home' }
      end
      format.js
    end
  end
  
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to root_url
  end
  
  private
  
  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end
end
