require 'spec_helper'

describe MicropostsController do
  create_user
  before { sign_in user, no_capybara: true }
  
  describe "creating a micropost with Ajax" do
    let(:params) { {micropost: {content: 'Lorem ipsum'}} }
    options = {klass: Micropost}
    
    it_behaves_like "ajax form", options
  end
end
