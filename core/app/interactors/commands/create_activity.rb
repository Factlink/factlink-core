require_relative '../pavlov'

module Commands
  class CreateActivity
    include Pavlov::Command

    arguments :graph_user, :action, :subject, :object

    def execute
      Activity.create(user: @graph_user, action: @action, subject: @subject, object: @object)
    end

    def authorized?
      @options[:current_user].id.to_s == @graph_user.user_id.to_s
    end
  end
end
