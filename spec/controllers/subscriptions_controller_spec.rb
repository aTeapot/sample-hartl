require 'spec_helper'

describe SubscriptionsController do
  create_user
  let(:author) { FactoryGirl.create(:user) }
  
  before { sign_in user, no_capybara: true }
  
  describe "creating a subscription with Ajax" do
    let(:params) { {subscription: {author_id: author.id}} }
    options = {klass: Subscription}
    
    it_behaves_like "ajax form", options
  end
  
  describe "destroying a subscription with Ajax" do
    before { user.follow! author }
    let(:subscription) { user.subscriptions.find_by(author_id: author.id) }
    let(:params) { {id: subscription.id} }
    options = {
      klass: Subscription,
      request_method: :delete,
      action: :destroy,
      count_change: -1
    }
    
    it_behaves_like "ajax form", options
  end
end
