DeadUserTopic = Struct.new(:slug_title, :title, :authority, :facts_count) do
  def formatted_authority
    1
  end
end
