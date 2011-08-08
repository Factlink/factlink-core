class FactGraph

  def self.recalculate
    reset_values
    1.times do
      Basefact.all.to_a.each {|f| f.calculate_user_opinion }
      5.times do 
        FactRelation.all.to_a.each {|f| f.calculate_influencing_opinion}
        Fact.all.to_a.each {|f| f.calculate_opinion}
      end
      calculate_authority
    end
  end
  def self.reset_values
  end
  def self.calculate_authority
  end
end