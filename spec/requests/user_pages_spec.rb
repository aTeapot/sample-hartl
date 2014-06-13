require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  describe 'profile page' do
    create_user
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: 'Foo') }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: 'Bar') }
    before { visit user_path(user) }
    
    it { should have_content(user.name) }
    it { should have_title(user.name) }
    
    describe 'microposts' do
      it { should have_content "Microposts (#{user.microposts.count})" }
      it { should have_content m1.content }
      it { should have_content m2.content }
      
      describe 'created by another user' do
        let(:another_user) { FactoryGirl.create(:user) }
        before do
          FactoryGirl.create(:micropost, user: another_user)
          visit user_path(another_user)
        end
        
        it "shouldn't have a delete link" do
          expect(page).to_not have_link 'delete'
        end
      end
    end
    
    describe 'follow/unfollow buttons' do
      let(:author) { FactoryGirl.create(:user) }
      before { sign_in user }
      
      describe "following a user" do
        before { visit user_path(author) }
        
        it "should increment the followed users count" do
          expect do
            click_button 'Follow'
          end.to change(user.followed_users, :count).by(1)
        end
        
        it "should increment the author's followers count" do
          expect do
            click_button 'Follow'
          end.to change(author.followers, :count).by(1)
        end
        
        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath "//input[@value='Unfollow']" }
        end
      end
      
      describe "unfollowing a user" do
        before do
          user.follow! author
          visit user_path(author)
        end
        
        it "should decrement the followed users count" do
          expect do
            click_button 'Unfollow'
          end.to change(user.followed_users, :count).by(-1)
        end
        
        it "should decrement the author's followers count" do
          expect do
            click_button 'Unfollow'
          end.to change(author.followers, :count).by(-1)
        end
        
        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath "//input[@value='Follow']" }
        end
      end
    end
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
      
      describe "after submission" do
        before { click_button submit }
        
        it { should have_title 'Sign up' }
        it 'should have error explanation' do
          within '#error_explanation' do
            should have_content 'error'
            should have_content 'The form contains'
            should have_selector 'ul'
          end
        end
        specify 'fields with errors should be inside right divs' do
          within 'form#new_user' do
            should have_selector 'div.field_with_errors', count: 6
            should have_selector 'label[for=user_name]', text: 'Name'
          end
        end
      end
    end
    
    describe "with valid information" do
      let(:new_user) { FactoryGirl.build(:user) }
      before { fill_in_user_form new_user }
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: new_user.email) }
        
        it { should have_title user.name }
        it { should have_success_message 'Welcome' }
        it { should have_signout_link }
      end
    end
  end

  describe 'edit' do
    create_user
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe 'page' do
      it { should have_content 'Update your profile' }
      it { should have_title 'Edit user' }
      it { should have_link 'change', href: 'http://gravatar.com/emails' }
    end
    
    describe 'with invalid information' do
      before { click_button 'Save changes' }
      
      it { should have_content 'error' }
    end
    
    describe 'with valid information' do
      let(:edited_user) { FactoryGirl.build(:edited_user) }
      before do
        fill_in_user_form(edited_user)
        click_button 'Save changes'
      end
      
      it { should have_title edited_user.name }
      it { should have_success_message 'updated' }
      it { should have_signout_link }
      specify { expect(user.reload.name).to  eq edited_user.name }
      specify { expect(user.reload.email).to eq edited_user.email }
    end
  end
  
  describe 'index' do
    create_user
    before do
      sign_in user
      visit users_path
    end
    
    it { should have_title   'All users' }
    it { should have_content 'All users' }
    
    describe 'pagination' do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }
      
      it { should have_selector '.pagination', count: 2 }
    
      it 'should list each user' do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
    
    describe 'delete links' do
      describe 'are not seen by ordinary users' do
        it { should_not have_link('delete') }
      end
      
      describe 'as an admin' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end
        
        it { should     have_link 'delete', href: user_path(User.find_by(admin: false)) }
        it { should_not have_link 'delete', href: user_path(admin) }
        it 'should be able to delete another user' do
          expect { click_link 'delete', match: :first }.to change(User, :count).by(-1)
        end
        describe 'should not be able to destroy itself' do
          before do
            sign_in admin, no_capybara: true
            delete user_path(admin)
          end
          specify { expect(response).to redirect_to(root_url) }
          specify { expect(User.find_by id: admin.id).not_to be_nil }
        end
      end
    end
  end
  
  describe 'following/followers' do
    let(:follower) { FactoryGirl.create(:user) }
    let(:author)   { FactoryGirl.create(:user) }
    before { follower.follow! author }
    
    describe 'followed users' do
      before do
        sign_in author
        visit followers_user_path(author)
      end
      
      it { should have_title full_title('Followers') }
      it { should have_selector 'h3', text: 'Followers' }
      it { should have_link follower.name, href: user_path(follower) }
    end
  end
end
