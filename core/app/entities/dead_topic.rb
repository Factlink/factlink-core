DeadTopic = Struct.new(:slug_title, :title, :current_user_authority, :facts_count) do
  def formatted_current_user_authority
    NumberFormatter.new(current_user_authority).as_authority
  end
end
