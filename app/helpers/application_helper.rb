module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title='')
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end
  
  def render_js(*args)
    escape_javascript(render(*args))
  end
  
  def alert(type, msg)
    content_tag(:div, msg, class: "alert alert-#{type}")
  end
end
