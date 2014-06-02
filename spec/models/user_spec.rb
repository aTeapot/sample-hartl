require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@example.com", password: 'ala123', password_confirmation: 'ala123') }
  subject { @user }
  
  context "methods" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:authenticate) }
  end

  it { should be_valid }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:name).is_at_most(50) }
  it { should ensure_length_of(:password).is_at_least(6) }
  xit { should_not allow_value('foo@bar..com').for(:email) }
  
  context "email" do
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
  
  context "password" do
    describe "when password is blank" do
      before do
        @user.password = ' '
        @user.password_confirmation = ' '
      end
      it { should_not be_valid }
    end
    
    describe "when password doesn't match confirmation" do
      before { @user.password = 'admin1' }
      it { should_not be_valid }
    end
    
    describe "returnt value of authenticate method" do
      before { @user.save }
      let(:found_user) { User.find_by(email: @user.email) }
      
      describe "with valid password" do
        it { should eq found_user.authenticate(@user.password) }
      end
      
      describe "with invalid password" do
        let(:user_with_invalid_password) { found_user.authenticate('sialala') }
        it { should_not eq user_with_invalid_password }
        specify { expect(user_with_invalid_password).to be_false }
      end
    end
  end
end
