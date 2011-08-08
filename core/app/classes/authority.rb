class Authority
  
  def Authority.for_graph_user(gu)
    
    derived_facts_count = []
    
    gu.real_created_facts.map { |f| f.id }.each do |f_id|
              # FactRelations poiting to facts created by the user. Exclude\
              # FactRelations created by the user himself.
      count = FactRelation.find(:from_fact_id => f_id)
                          .except(:created_by_id => gu.id)
                          .count

      if count > 0
      	derived_facts_count << count
    	end
    end

    
    auth = derived_facts_count.inject(1.0) { |sum, fact_relation_count | sum + Math.log(fact_relation_count) }
    
    return auth
  end

end