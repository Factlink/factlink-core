module UserHelper
  def show_message message, &block
    capture(&block) unless current_user.seen_messages.include? message.to_s
  end
end
