DeadChannel = Struct.new(:id) do
  def acts_as_class_for_authority
    'Channel'
  end
end

