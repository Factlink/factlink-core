require_relative '../pavlov'

module Commands
  class SendActivityMailToUser
    include Pavlov::Command

    arguments :user, :activity

    def execute
      ActivityMailer.new_activity(@user, @activity).deliver
    end
  end
end
