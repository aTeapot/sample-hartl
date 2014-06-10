require 'spec_helper'

describe User do
  before  { @user = FactoryGirl.build(:user) }
  subject { @user }
  
  it { should have_many(:microposts).dependent(:destroy) }
  
  context "methods" do
    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:remember_token) }
    it { should respond_to(:authenticate) }
    it { should respond_to(:admin) }
    it { should respond_to(:microposts) }
  end

  it { should be_valid }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should ensure_length_of(:name).is_at_most(50) }
  it { should ensure_length_of(:password).is_at_least(6) }
  it { should_not be_admin }
  
  context "email" do
    describe "when email format is invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
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
    
    describe "email address with mixed case" do
      let(:mixed_case_email) { 'eMoMarTynKa@auC.pl' }
      it "should be downcased before save" do
        @user.email = mixed_case_email
        @user.save
        expect(@user.reload.email).to eq mixed_case_email.downcase
      end
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
  
  describe 'remember token' do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
  
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle! :admin
    end
    
    it { should be_admin }
  end
  
  describe 'microposts association' do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end
    
    its('microposts.to_a') { should eq [newer_micropost, older_micropost] }
    
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect do
          Micropost.find(micropost)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
