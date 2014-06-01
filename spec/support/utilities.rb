def full_title(page_title=nil)
  base_title = "Ruby on Rails Tutorial Sample App"
  "#{base_title} | #{page_title}" if page_title
end
