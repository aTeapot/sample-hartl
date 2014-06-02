require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com") }
  subject { @user }
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should be_valid }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:name).is_at_most(50) }
  xit { should_not allow_value('foo@bar..com').for(:email) }
  
  describe "when email format is invalid" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_address|
      it { should_not allow_value(invalid_address).for(:email) }
    end
  end
  
  describe "when email format is valid" do
    addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
    addresses.each do |valid_address|
      it { should allow_value(valid_address).for(:email) }
    end
  end
  
  describe "when email addres is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
end

