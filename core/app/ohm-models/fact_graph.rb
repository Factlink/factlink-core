class FactGraph

  def self.recalculate
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
  
  def self.export_opiniated(writer,fact,prefix="")
    writer.write(prefix + export_believers(fact.opiniated(:beliefs))) if fact.opiniated(:beliefs).size > 0
    writer.write(prefix + export_disbelievers(fact.opiniated(:disbeliefs))) if fact.opiniated(:disbeliefs).size > 0
    writer.write(prefix + export_doubters(fact.opiniated(:doubts))) if fact.opiniated(:doubts).size > 0
  end

  def self.export(writer)
    writer.write("# coding: utf-8\n\n")

    GraphUser.all.each do |gu|
      writer.write(export_user(gu))
      print "exporting #{gu.user.username}\n"
    end
    writer.write("\n")
    
    ([''] + GraphUser.all.to_a.map {|gu| gu.id}).each do |x|
      fs = Fact.find(:created_by_id => x)
      if x != '' && fs.size > 0
        writer.write("\n")
        writer.write(export_activate_user(GraphUser[x]))
      end
      fs.each do |fact|
        writer.write("  "+export_fact(fact))
        export_opiniated(writer,fact,"    ")
        print "."
      end
    end
    
    ([''] + GraphUser.all.to_a.map {|gu| gu.id}).each do |x|
      fs = FactRelation.find(:created_by_id => x)
      if x != '' && fs.size > 0
        writer.write("\n")
        writer.write(export_activate_user(GraphUser[x]))
      end
      fs.each do |fact_relation|
        writer.write("  "+export_fact_relation(fact_relation))
        export_opiniated(writer,fact_relation,"    ")
        print "."
      end
      puts
    end

    GraphUser.all.each do |gu|
      if gu.channels.size > 0
          writer.write("\n")
          writer.write(export_activate_user(gu))
      end
        
      gu.channels.each do |channel|
        writer.write("  "+export_channel(channel))
        channel.internal_facts.each do |f|
          writer.write("    "+export_add_fact(f))
        end
        channel.delete_facts.each do |f|
          writer.write("    "+export_del_fact(f))
        end
        channel.contained_channels.each do |ch|
          writer.write("    "+export_sub_channel(ch))
        end
      end
    end
  end
end