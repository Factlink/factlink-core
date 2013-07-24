require 'pavlov'

module Commands
  class SendActivityMailToUser
    include Pavlov::Command

    arguments :user_id, :activity_id, :pavlov_options

    def execute
      ActivityMailer.new_activity(user_id, activity_id).deliver
    end
  end
end
