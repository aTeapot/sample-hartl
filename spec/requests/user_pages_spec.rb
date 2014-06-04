require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  describe 'profile page' do
    # let(:user) { User.create(name: 'Ala', email: 'ala@123.pl', password: 'ala123',
                             # password_confirmation: 'ala123') }
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
  
  describe "signup page" do
    before { visit signup_path }
    
    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end
  
  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end
    
    describe "with valid information" do
      before do
        fill_in "Name",         with: "Gryzelda Ciołek"
        fill_in "Email",        with: "mietekbylzajety@o2.pl"
        fill_in "Password",     with: "ala123"
        fill_in "Confirmation", with: "ala123"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end
