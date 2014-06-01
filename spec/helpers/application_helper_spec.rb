require 'spec_helper'

describe ApplicationHelper do
  
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "full_title" do
    it "should generate the right title for foo" do
      expect(full_title("foo")).to eq("#{base_title} | foo")
    end

    it "should generate the right default title" do
      expect(full_title).to eq(base_title)
    end
  end
end
