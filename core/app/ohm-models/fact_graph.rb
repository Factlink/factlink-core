class FactGraph
  def self.recalculate
    new.recalculate
  end

  def debug x
    @logger ||= Logger.new(STDERR)
    @logger.info "#{Time.now} #{x}"
    $stdout.flush
  end

  def recalculate
      calculate_authority

      calculate_user_opinions_of_all_base_facts
      5.times do |i|
        calculate_fact_relation_influencing_opinions i

        calculate_fact_opinions i
      end
  end

  def calculate_fact_relation_influencing_opinions i
    debug "Calculating fact relation influencing opinions (#{i})"
    FactRelation.all.ids.each do |id|
      fr = FactRelation[id]
      fr.calculate_influencing_opinion
    end
  end

  def calculate_fact_opinions i
    debug "Calculating fact opinions (#{i})"
    Fact.all.ids.each do |id|
      f = Fact[id]
      f.calculate_opinion
    end
  end

  def calculate_user_opinions_of_all_base_facts
    debug "Calculating user opinions on basefacts"
    Basefact.all.ids.each do |id|
      bf = Basefact[id]
      bf.calculate_user_opinion
    end
  end

  def calculate_authority
    debug "Calculating Authority"
    Authority.run_calculation(authority_calculators)
  end

  def authority_calculators
    [
      MapReduce::FactAuthority,
      MapReduce::ChannelAuthority,
      MapReduce::TopicAuthority,
      MapReduce::FactCredibility,
      MapReduce::FactRelationCredibility
    ]
  end

  def self.export_opiniated(writer,fact,prefix="")
    writer.write(prefix + LoadDsl.export_believers(fact.opiniated(:believes))) if fact.opiniated(:believes).size > 0
    writer.write(prefix + LoadDsl.export_disbelievers(fact.opiniated(:disbelieves))) if fact.opiniated(:disbelieves).size > 0
    writer.write(prefix + LoadDsl.export_doubters(fact.opiniated(:doubts))) if fact.opiniated(:doubts).size > 0
  end

  def self.export(writer, options={})
    verbose = options.has_key?(:verbose) and options[:verbose]

    writer.write(LoadDsl.export_header)

    GraphUser.all.each do |gu|
      writer.write(LoadDsl.export_user(gu))
      print "." if verbose
    end
    writer.write("\n")

    Site.all.each do |s|
      writer.write(LoadDsl.export_site(s))
      print "." if verbose
    end
    writer.write("\n")

    ([''] + GraphUser.all.to_a.map {|gu| gu.id}).each do |x|
      fs = Fact.find(:created_by_id => x)
      if x != '' && fs.size > 0
        writer.write("\n")
        writer.write(LoadDsl.export_activate_user(GraphUser[x]))
      end
      fs.each do |fact|
        writer.write("  "+LoadDsl.export_fact(fact))
        self.export_opiniated(writer,fact,"    ")
        print "." if verbose
      end
    end

    ([''] + GraphUser.all.to_a.map {|gu| gu.id}).each do |x|
      fs = FactRelation.find(:created_by_id => x)
      if x != '' && fs.size > 0
        writer.write("\n")
        writer.write(LoadDsl.export_activate_user(GraphUser[x]))
      end
      fs.each do |fact_relation|
        writer.write("  "+LoadDsl.export_fact_relation(fact_relation))
        self.export_opiniated(writer,fact_relation,"    ")
        print "."  if verbose
      end
      puts if verbose
    end

    GraphUser.all.each do |gu|
      if ChannelList.new(gu).channels.size > 0
        writer.write("\n")
        writer.write(LoadDsl.export_activate_user(gu))
      end

      #use Channel.find because we also want deleted channels
      Channel.find(:created_by_id => gu.id ).each do |channel|
        writer.write("  "+LoadDsl.export_channel(channel))
        channel.sorted_internal_facts.each do |f|
          if f and f.data_id
            writer.write("    "+LoadDsl.export_add_fact(f))
          end
        end
        channel.sorted_delete_facts.each do |f|
          if f and f.data_id
            writer.write("    "+LoadDsl.export_del_fact(f))
          end
        end
        channel.contained_channels.each do |ch|
          writer.write("    "+LoadDsl.export_sub_channel(ch))
        end
      end
    end
    writer.write(LoadDsl.export_footer)
  end
end
