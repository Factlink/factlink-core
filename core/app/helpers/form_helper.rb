module FormHelper
  def possible_error_for_field(resource, fieldname)
    if resource.errors[fieldname].any?
      content = resource.errors[fieldname].join("; ")

      content_tag :div, content, class: 'text-error'
    end
  end 
end
