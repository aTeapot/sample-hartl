shared_examples "search form" do |collection_name|
  it { should have_button "Search" }
  
  describe "valid search" do
    before { submit_search(search_texts[:phrase]) }
    
    it { should have_content search_texts[:found1] }
    it { should have_content search_texts[:found2] }
    it { should_not have_content search_texts[:not_found] }
    it { should have_content "Found #{collection_name}" }
    it { should have_selector "#search[value=#{search_texts[:phrase]}]" }
    
    describe "followed by blank search" do
      before { submit_search('   ') }
      
      it { should have_selector ".#{collection_name} li",
                                count: collection_size }
      it { should_not have_content "Found #{collection_name}" }
    end
  end
  
  describe "search with no results" do
    before { submit_search('qwerty') }
    
    it { should have_content "No #{collection_name} found" }
    it { should_not have_selector ".#{collection_name} li" }
  end
end
