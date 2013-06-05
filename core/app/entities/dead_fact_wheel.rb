DeadFactWheel = Struct.new(
  :authority,
  :believe_percentage,
  :disbelieve_percentage,
  :doubt_percentage,
  :user_opinion
) do
  def is_user_opinion(type)
    user_opinion.to_s == "#{type.to_s}s"
  end
end
