class RelatedUsersCalculator
  def related_users(facts, limit=5)
    facts.map{|f| f.interacting_users}.reduce(:|).andand.sort_by(:cached_authority, :order => "DESC", :limit => limit)
  end
end

