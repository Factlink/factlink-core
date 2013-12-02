DeadTopic = Struct.new(:slug_title, :title, :current_user_authority,
    :facts_count, :favouritours_count) do

  def formatted_current_user_authority
    return nil unless current_user_authority

    1
  end
end
