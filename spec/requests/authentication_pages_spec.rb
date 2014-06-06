require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  before { visit signin_path }
  
  describe "signin page" do
    it { should have_title 'Sign in' }
    it { should have_selector 'h1', text: 'Sign in' }
  end
  
  describe 'signin' do
    describe 'with invalid information' do
      before { click_button 'Sign in' }
      
      it { should have_title 'Sign in' }
      it { should have_error_message }
      
      describe "after visiting another page" do
        before { click_link 'Home' }
        it { should_not have_error_message }
      end
    end
    
    describe 'with valid information' do
      create_user
      before { valid_signin(user) }
      
      it { should have_title user.name }
      it { should have_link 'Profile', href: user_path(user) }
      it { should have_signout_link }
      it { should_not have_signin_link }
      
      describe 'followed by signout' do
        before { click_link 'Sign out' }
        
        it { should have_success_message 'signed out' }
        it { should have_signin_link }
      end
    end
  end
end
