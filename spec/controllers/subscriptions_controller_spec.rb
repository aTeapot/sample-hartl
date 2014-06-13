require 'spec_helper'

describe SubscriptionsController do
  create_user
  let(:author) { FactoryGirl.create(:user) }
  
  before { sign_in user, no_capybara: true }
  
  describe "creating a subscription with Ajax" do
    it "should increment the Subscription count" do
      expect do
        xhr :post, :create, subscription: { author_id: author.id }
      end.to change(Subscription, :count).by(1)
    end
    
    it "should respond with success" do
      xhr :post, :create, subscription: { author_id: author.id }
      expect(response).to be_success
    end
  end
  
  describe "destroying a subscription with Ajax" do
    before { user.follow! author }
    let(:subscription) do
      user.subscriptions.find_by(author_id: author.id)
    end
    
    it "should decrement the Subscription count" do
      expect do
        xhr :delete, :destroy, id: subscription.id
      end.to change(Subscription, :count).by(-1)
    end
    
    it "should respond with success" do
      xhr :delete, :destroy, id: subscription.id
      expect(response).to be_success
    end
  end
  
end
