include ApplicationHelper

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button 'Sign in'
end

def create_user
  let(:user) { FactoryGirl.create(:user) }
end

flashes = [:success, :error]

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
