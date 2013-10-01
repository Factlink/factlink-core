module Util
  module Validations
    def validate_string_length param_name, param, length
      if param.length > length
        errors.add param_name,
          "should not be longer than #{length} characters."
      end
    end

    def validate_non_empty_list param_name, param
      if ! param.respond_to? :each
        errors.add param_name, 'should be a list'
      elsif param.length == 0
        errors.add param_name, 'should not be empty'
      end
    end
  end
end
