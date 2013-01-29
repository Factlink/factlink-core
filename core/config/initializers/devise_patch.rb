Devise::ParamFilter.class_eval do
  def param_requires_string_conversion?(_value); true; end
end
