DeadTopic = Struct.new(:slug_title, :title, :authority, :facts_count) do
  def formatted_authority
    NumberFormatter.new(authority).as_authority
  end
end
