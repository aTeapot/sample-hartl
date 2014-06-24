require 'spec_helper'

describe "Static pages" do
  
  subject { page }

  describe "Home page" do
    before { visit root_path }
    let(:heading)    {'Sample App'}
    let(:page_title) {''}
    
    it_behaves_like 'static page'
    it { should_not have_title(full_title('Home')) }
    
    describe "for signed-in users" do
      create_user
      before do
        FactoryGirl.create(:micropost, user: user, content: 'Lorem ipsum')
        FactoryGirl.create(:micropost, user: user, content: 'Dolor sit amet')
        sign_in user
        visit root_path
      end
      
      it { should have_content '2 microposts' }
      
      it "should render the user's feed" do
        user.feed.each do |post|
          expect(page).to have_selector "li##{post.id}", text: post.content
        end
      end
      
      describe 'feed pagination' do
        describe 'with few microposts' do
          it { should_not have_selector '.pagination'}
        end
        
        describe 'with > 30 microposts' do
          before do
            31.times { FactoryGirl.create(:micropost, user: user) }
            visit root_url
          end
          
          it { should have_selector '.pagination' }
        end
      end
      
      describe "follower/following stats" do
        let(:follower) { FactoryGirl.create(:user) }
        before do
          follower.follow! user
          visit root_path
        end
        
        it { should have_link '1 followers', href: followers_user_path(user) }
        it { should have_link '0 following', href: following_user_path(user) }
      end
    end
  end
  
  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { heading }
    
    it_behaves_like 'static page'
  end
  
  describe "About page" do
    before { visit about_path }
    
    let(:heading)    { 'About Us' }
    let(:page_title) { heading }
    
    it_behaves_like 'static page'
  end
  
  describe "Contact page" do
    before { visit contact_path }
    
    let(:heading)    { 'Contact' }
    let(:page_title) { heading }
    
    it_behaves_like 'static page'
  end
  
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title)
  end
end
