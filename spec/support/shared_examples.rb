shared_examples 'static page' do
  it { should have_selector('h1', text: heading) }
  it { should have_title(full_title(page_title)) }
end

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

shared_examples_for "ajax form" do |options|
  defaults = { count_change: 1, request_method: :post, action: :create }
  options = options.reverse_merge(defaults)
  
  it "should change the #{options[:klass].name} count by #{options[:count_change]}" do
    expect do
      xhr options[:request_method], options[:action], params
    end.to change(options[:klass], :count).by(options[:count_change])
  end
  
  it "should respond with success" do
    xhr options[:request_method], options[:action], params
    expect(response).to be_success
  end
end
