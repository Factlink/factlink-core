webform_id = case Rails.env.to_sym
  when :development then 91
  when :test        then 1
  when :staging     then 94
  when :production  then 95
  end

FactlinkUI::Application.config.sirportly_webform_id = webform_id
