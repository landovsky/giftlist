class PaginatingDecorator < Draper::CollectionDecorator
  
  delegate :current_page, :total_pages #použité metody z modulu Pagination
  
  def pagination(options = {})
    style = options[:simple] if options[:simple]
    
  previous_label = "předchozí" #"&laquo;"
  if object.current_page == 0; previous_page = ""; else; previous_page = "?page=#{object.current_page - 1}".html_safe; end
  previous_class = "strong "
  previous_class += "disabled" if object.current_page == 0
  next_label = "další" #"&raquo;"
  if object.current_page == object.total_pages; next_page = ""; else; next_page = "?page=#{object.current_page + 1}".html_safe; end
  next_class = "strong "
  next_class += "disabled" if object.current_page == object.total_pages
  
  previous_btn = h.content_tag :li, class: previous_class do h.link_to previous_label, previous_page end
  
  page_btn = ""
  
  pages = page_set(object, style: :simple, offset: 3) 
  
  pages.each do |i|
    label = i+1
    active = "active" if i == object.current_page 
    page_btn += "<li class=\"#{active}\"><a>...</a></li>" if i == pages.last && pages[-2] != pages.last-1 # vloží prázdný element mezi 1. a další nesouvisející
    page_btn += "<li class=\"#{active}\"><a href=\"#{h.current_path}?page=#{i}\">#{label}</a></li>"
    page_btn += "<li class=\"#{active}\"><a>...</a></li>" if i == 0 && pages[1] != 1 # vloží prázdný element před poslední a nesouvisející
  end
  
  next_btn = h.content_tag :li, class: next_class do h.link_to next_label, next_page end
  h.content_tag :ul, class: "pagination pagination-sm" do
    previous_btn + next_btn + page_btn.html_safe
  end
  
end
  
  private
 
def page_set(object, options = {})
    current_page = object.current_page
    total_pages = object.total_pages
    style = options[:style] if options[:style]
    style ||= :full
    offset = options[:offset] if options[:offset]
    offset ||= 2
  
    set = []
    (0..total_pages).each do |i|
      case style
      when :full
        set << i
      when :simple
        set << i if i == total_pages
        set << i if (current_page-offset..current_page+offset).include?i 
        set << i if i == 0
      end
    end
    return set.uniq
end

def _eval_(return_if_ok, condition, return_if_not_ok)
  
end  
    
end