module UserHelper

  def interesting_users_without(users=[], number=5)
    interesting_users = GraphUser.top(number + users.length).map{|x| x.user}
    interesting_users.delete_if { |u| !u || users.include?(u) }.take(number)
  end

  def current_graph_user
    current_user.andand.graph_user
  end

  def show_message message, &block
    unless (current_user.seen_messages.include? message.to_s)
      capture(&block)
    end
  end

end