module Admin::UsersHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  def sign_in_count_class_for(user)
    case user.sign_in_count
    when nil
    when 0
      "important"
    when 1
      "warning"
    else
      "success"
    end
  end

  def features_count_class_for(user)
    case user.features_count
    when 0
      "error"
    else
      "important"
    end
  end
end
