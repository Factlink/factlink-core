module TopicBeliefExpressions
  def reset
    Authority.run_calculation
  end

  def authority opts={}
    reset
    Authority.from(opts[:from], opts.slice(:of)).to_f.should == opts[:should_be]
  end
end
