DeadUser = StrictStruct.new(
  :id,
  :name,
  :username,
  :gravatar_hash,
  :deleted,
) do

  alias :to_hash :to_h
end
