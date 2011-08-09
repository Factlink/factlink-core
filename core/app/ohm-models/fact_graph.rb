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
  def self.export_opiniated(writer,fact)
    writer.write(export_believers(fact.opiniated(:beliefs))) if fact.opiniated(:beliefs).size > 0
    writer.write(export_disbelievers(fact.opiniated(:disbeliefs))) if fact.opiniated(:disbeliefs).size > 0
    writer.write(export_doubters(fact.opiniated(:doubts))) if fact.opiniated(:doubts).size > 0
    writer.write("\n") if fact.interacting_users.size > 0
  end

  def self.export(writer)
    GraphUser.all.each do |gu|
      writer.write(export_user(gu))
      print "."
    end
    writer.write("\n")

    Fact.all.each do |fact|
      writer.write(export_fact(fact))
      export_opiniated(writer,fact)
      print "."
    end

    FactRelation.all.each do |fact_relation|
      writer.write(export_fact_relation(fact_relation))
      export_opiniated(writer,fact_relation)
      print "."
    end
    puts
  end
end