DeadUserTopic = Struct.new(:slug_title, :title, :authority) do
  def formatted_authority
    NumberFormatter.new(authority).as_authority
  end
end
