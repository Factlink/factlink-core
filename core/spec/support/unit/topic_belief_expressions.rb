module TopicBeliefExpressions
  def reset
    FactGraph.new.calculate_authority
  end

  def authority opts={}
    reset
    if opts[:from]
      Authority.from(opts[:from], opts.slice(:for)).to_f.should == opts[:should_be]
    else
      Authority.on(opts[:on], opts.slice(:for)).to_f.should == opts[:should_be]
    end
  end
end
