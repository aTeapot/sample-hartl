require 'spec_helper'

describe Micropost do
  create_user
  before  { @micropost = user.microposts.build(content: 'Hello') }
  subject { @micropost }
  
  it { should belong_to :user }
  
  it { should respond_to :content }
  it { should respond_to :user_id }
  it { should respond_to :user }
  its(:user) { should eq user }
  
  it { should be_valid }
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:content) }
  it { should ensure_length_of(:content).is_at_most(140) }
  
end
