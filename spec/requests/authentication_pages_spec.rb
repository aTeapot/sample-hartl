require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }
    it { should have_title 'Sign in' }
    it { should have_selector 'h1', text: 'Sign in' }
  end
  
  describe 'signin' do
    before { visit signin_path }
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
      before { sign_in user }
      
      it { should have_title user.name }
      it { should have_link 'Profile',  href: user_path(user) }
      it { should have_link 'Users',    href: users_path }
      it { should have_link 'Settings', href: edit_user_path(user) }
      it { should have_signout_link }
      it { should_not have_signin_link }
      
      describe 'followed by signout' do
        before { click_link 'Sign out' }
        
        it { should have_success_message 'signed out' }
        it { should have_signin_link }
        it { should_not have_link 'Profile',  href: user_path(user) }
        it { should_not have_link 'Users',    href: users_path }
        it { should_not have_link 'Settings', href: edit_user_path(user) }
        it { should_not have_signout_link }
      end
    end
  end
  
  describe 'authorization' do
    describe 'for non-signed-in users' do
      create_user
      
      describe 'in the Users controller' do
        describe 'visiting the edit page' do
          before { visit edit_user_path(user) }
          it { should have_title 'Sign in' }
          it { should have_notice_message 'sign in' }
        end
        
        describe 'submitting to the update action' do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe 'visiting the users index' do
          before { visit users_path }
          it { should have_title 'Sign in' }
          it { should have_notice_message 'sign in' }
        end
      end
      
      describe 'in the Microposts controller' do
        describe 'submitting to the create action' do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end
        
        describe 'submitting to the destroy action' do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
      
      describe 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button 'Sign in'
        end
        
        describe 'after signing in' do
          it 'should render the desired protected page' do
            expect(page).to have_title 'Edit user'
          end
          
          describe 'when signing in again' do
            before do
              click_link 'Sign out'
              sign_in user
            end
            it { should have_title user.name }
          end
        end
      end
    end
    
    describe "as wrong user" do
      create_user
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
      before { sign_in user, no_capybara: true }
      
      describe 'submitting a GET request to the Users#edit action' do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe 'submitting a PATCH request to the Users#update action' do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
    
    describe 'as non-admin' do
      create_user
      let(:non_admin) { FactoryGirl.create(:user) }
      before { sign_in non_admin, no_capybara: true }
      
      describe 'submitting a DELETE request to the Users#destroy action' do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
      
      describe 'submitting a PATCH request to become admin' do
        let(:params) { { user: { admin: true, password: non_admin.password,
                                 password_confirmation: non_admin.password } } }
        before { patch user_path(non_admin), params }
        specify { expect(non_admin.reload).not_to be_admin }
      end
    end
    
    describe 'as signed in user' do
      create_user
      before { sign_in user, no_capybara: true }
      
      describe "shouldn't be able to reach User#create action" do
        let(:params) { { user: FactoryGirl.attributes_for(:user) } }
        
        specify { expect { post users_path, params }.not_to change(User, :count) }
        
        describe 'and should be redirected to root path' do
          before { post users_path, params }
          specify { expect(response).to redirect_to(root_url) }
        end
      end
      
      describe "shouldn't be able to reach User#new action" do
        before { get new_user_path }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
