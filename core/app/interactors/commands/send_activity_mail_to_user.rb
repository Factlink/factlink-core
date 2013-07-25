require 'pavlov'

module Commands
  class SendActivityMailToUser
    include Pavlov::Command

    arguments :user_id, :activity_id
    attribute :pavlov_options, Hash, default: {}

    def execute
      ActivityMailer.new_activity(user_id, activity_id).deliver
    end
  end
end
