module UserHelper

  def current_graph_user
    current_user.andand.graph_user
  end

  def show_message message, &block
    capture(&block) unless (current_user.seen_messages.include? message.to_s)
  end

  def nil_if_empty x
    x.blank? ? nil : x
  end

end
