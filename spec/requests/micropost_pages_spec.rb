require 'spec_helper'

describe "Micropost Pages" do
  
  subject { page }
  
  create_user
  before { sign_in user }
  
  describe "micropost creation" do
    before { visit root_path }
    
    describe "with invalid information" do
      it "should not create micropost" do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end
      
      describe "error messages", js: true do
        before { click_button 'Post' }
        it { should have_error_message }
      end
    end
    
    describe "with valid information" do
      let(:micropost_text) { "Ala ma kota" }
      before { fill_in 'micropost_content', with: micropost_text }
      
      it "should create micropost" do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end
      
      it "should update page content", js: true do
        click_button 'Post'
        
        should_not have_selector "#micropost_content[value='#{micropost_text}']"
        should_not have_content 'characters left'
        should have_success_message "Micropost created"
        should have_selector '.microposts li', text: micropost_text
        should have_content '1 micropost'
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }
    
    describe "as correct user" do
      before { visit root_path }
      specify do
        expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
