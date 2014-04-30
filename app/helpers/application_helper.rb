# This helper contains application wide helpers
# There shouldn't be anything specific in this file.
module ApplicationHelper
  def footer_item name, path
    content_tag(:li, class: 'footer-item') do
      link_to(name, path, class: 'footer-item-link')
    end
  end
end
