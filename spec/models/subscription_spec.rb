require 'spec_helper'

describe Subscription do
  let(:follower) { FactoryGirl.create(:user) }
  let(:author)   { FactoryGirl.create(:user) }
  let(:subscription) { follower.subscriptions.build(author_id: author.id) }
  
  subject { subscription }
  
  it { should be_valid }
  
  describe "follower methods" do
    it { should respond_to :follower }
    it { should respond_to :author }
    its(:follower) { should eq follower }
    its(:author)   { should eq author }
  end
  
  it { should validate_presence_of :author_id }
  it { should validate_presence_of :follower_id }
end
