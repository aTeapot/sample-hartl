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
      it { should have_selector '.alert.alert-error' }
      
      describe "after visiting another page" do
        before { click_link 'Home' }
        it { should_not have_selector '.alert.alert-error' }
      end
    end
    
    describe 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button 'Sign in'
      end
      
      it { should     have_title user.name }
      xit { should     have_link 'Profile',  href: user_path(user) }
      xit { should     have_link 'Sign out', href: signout_path }
      xit { should_not have_link 'Sign in',  href: signin_path }
    end
  end
end
