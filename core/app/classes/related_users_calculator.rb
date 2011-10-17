class RelatedUsersCalculator
  def related_users(facts)
    facts.map{|f| f.interacting_users}.reduce(:|)
  end
end

