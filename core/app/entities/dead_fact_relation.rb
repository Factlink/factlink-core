DeadFactRelation = Struct.new(:id) do
  def acts_as_class_for_authority
    'FactRelation'
  end
end
