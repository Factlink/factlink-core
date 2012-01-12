require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper
include ActionView::Helpers::JavaScriptHelper

namespace :template do
  task :create do
    filename = File.join(Rails.root, "tmp", "mustache-templates.html")
    File.open(filename, 'w') { |f| f.write(load_mustache_templates) }
  end
end
