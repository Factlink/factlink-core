class RelatedUsersCalculator
  def related_users(facts)
    facts.map{|f| f.interacting_users}.reduce(:|).andand.sort(:by => :cached_authority, :order => "DESC")
  end
end

