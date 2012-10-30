require_relative '../pavlov'

module Commands
  class SendActivityMailToUser
    include Pavlov::Command

    arguments :user, :activity

    def execute
      ActivityMailer.new_activity(@user, @activity).deliver
    end

    def authorized?
      @options[:current_user]
    end
  end
end
