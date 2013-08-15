module PagesHelper
  def menu_item(page_path, page_title)
    request_path = URI.parse(request.fullpath).path
    html_class = pages_path(page_path) == request_path ? 'active': ''
    content_tag :li,
      link_to(page_title, pages_path(page_path)),
      class: html_class
  end
end
