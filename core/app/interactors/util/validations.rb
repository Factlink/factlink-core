module Util
  module Validations
    def validate_string_length param_name, param, length
      if param.length > length
        raise Pavlov::ValidationError,
          "#{param_name.to_s} should not be longer than #{length} characters."
      end
    end

    def validate_non_empty_list param_name, param
      raise Pavlov::ValidationError, "#{param_name} should be a list"    unless param.respond_to? :each
      raise Pavlov::ValidationError, "#{param_name} should not be empty" unless param.length > 0
    end
  end
end
