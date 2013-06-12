DeadGraphUser = Struct.new(:id) do
  def acts_as_class_for_authority
    'GraphUser'
  end
end
