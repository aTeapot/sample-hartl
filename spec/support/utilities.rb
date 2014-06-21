include ApplicationHelper

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in then not using Capybara
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_columns(remember_token: User.digest(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button 'Sign in'
  end
end

def create_user
  let(:user) { FactoryGirl.create(:user) }
end

def fill_in_user_form(user)
  fill_in "Name",         with: user.name
  fill_in "Email",        with: user.email
  fill_in "Password",     with: user.password
  fill_in "Confirmation", with: user.password
end

def submit_search(search_text)
  fill_in :search, with: search_text
  click_button 'Search'
end

flashes = [:success, :error, :notice]

flashes.each do |type|
  RSpec::Matchers.define "have_#{type}_message" do |message|
    match do |page|
      expect(page).to have_selector ".alert.alert-#{type}", text: message
    end
  end
end

RSpec::Matchers.define "have_signin_link" do
  match do |page|
    expect(page).to have_link 'Sign in',  href: signin_path
  end
end

RSpec::Matchers.define "have_signout_link" do
  match do |page|
    expect(page).to have_link 'Sign out',  href: signout_path
  end
end
