require 'spec_helper'

describe "User pages" do
  
  subject { page }
  
  describe 'profile page' do
    # let(:user) { User.create(name: 'Ala', email: 'ala@123.pl', password: 'ala123',
                             # password_confirmation: 'ala123') }
    create_user
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
      let(:user_email) { 'mietekbylzajety@o2.pl' }
      before do
        fill_in "Name",         with: "Gryzelda Ciołek"
        fill_in "Email",        with: user_email
        fill_in "Password",     with: "ala123"
        fill_in "Confirmation", with: "ala123"
      end
      
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: user_email) }
        
        it { should have_title user.name }
        it { should have_success_message 'Welcome' }
        it { should have_signout_link }
      end
    end
  end

end
