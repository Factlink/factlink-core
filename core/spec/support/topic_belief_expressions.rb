module TopicBeliefExpressions
  def possible_reset
    unless @nothing_happened
      Authority.run_calculation
      @nothing_happened = true
    end
  end

  def something_happened
    @nothing_happened = false
  end

  def authority opts={}
    possible_reset
    Authority.from(opts[:from], opts.slice(:of)).to_f.should == opts[:should_be]
  end
end
