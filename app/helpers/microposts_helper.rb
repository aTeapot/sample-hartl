module MicropostsHelper
  def optional_delete_link(micropost)
    if current_user?(micropost.user)
      link_to 'delete', micropost, method: :delete,
                                   data: { confirm: 'Are you sure?' },
                                   title: micropost.content
    end
  end
  
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join ' '))
  end
  
  private
  
  def wrap_long_string(text, max_width = 30)
    zero_width_space = "&#8203;"
    regex = /.{1,#{max_width}}/
    (text.length < max_width) ? text :
                                text.scan(regex).join(zero_width_space)
  end
end
