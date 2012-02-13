module TopicBeliefExpressions
  def possible_reset
    unless @nothing_happened
      FactGraph.reset_values
      FactGraph.recalculate
      @nothing_happened = true
    end
  end

  def something_happened
    @nothing_happened = false
  end

  def authority opts={}
    possible_reset
    Authority.from(opts[:on], opts.slice(:of)).to_f.should == opts[:should_be]
  end
end
