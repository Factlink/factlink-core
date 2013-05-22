DeadFact = Struct.new(
	:id,
	:site_url,
	:displaystring
) do
  def to_s
  	displaystring
  end
end
