module FormHelper
  def possible_error_for_field(resource, fieldname)
    if resource.errors[fieldname].any?
      content = resource.errors[fieldname].join(", ")
      content = "(error: #{content})"

      content_tag :div, class: 'field_with_errors' do 
        content_tag(:span, content, class: 'help_inline')
      end
    end
  end 
end
