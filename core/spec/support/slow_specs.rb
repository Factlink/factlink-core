module SlowSpecs
  def slow_test_it text, *args, &block
    if ENV['IS_FEATURE_BUILD']
      pending text
    else
      it text, *args, &block
    end
  end
 end
