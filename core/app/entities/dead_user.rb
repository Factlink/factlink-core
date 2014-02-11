DeadUser = StrictStruct.new(
  :id,
  :name,
  :username,
  :gravatar_hash,
  :deleted,
) do

  def serializable_hash(*args)
    to_h
  end
  def to_hash(*args)
    to_h
  end
  def as_json(*args)
    to_h
  end
end
