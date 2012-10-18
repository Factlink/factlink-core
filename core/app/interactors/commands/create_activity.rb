require_relative '../pavlov'

module Commands
  class CreateActivity
    include Pavlov::Command

    arguments :graph_user, :action, :subject

    def execute
      Activity.create(user: @graph_user,action: @action, subject: @subject, object: nil)
    end

    def authorized?
      @options[:current_user].id == @graph_user.user_id
    end
  end
end
