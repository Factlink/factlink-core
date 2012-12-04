module PagesHelper
  def menu_item(page_path, page_title)
    content_tag(:li, (link_to page_title, pages_path(page_path)), class: (pages_path(page_path) == request.fullpath ) ? 'active': '')
  end
end
