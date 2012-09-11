module UserHelper

  def current_graph_user
    current_user.andand.graph_user
  end

  def show_message message, &block
    capture(&block) unless (current_user.seen_messages.include? message.to_s)
  end

end