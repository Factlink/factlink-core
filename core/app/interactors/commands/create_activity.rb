require 'pavlov'

module Commands
  class CreateActivity
    include Pavlov::Command

    arguments :graph_user, :action, :subject, :object

    def execute
      Activity.create(user: @graph_user, action: @action, subject: @subject, object: @object)
    end
  end
end
