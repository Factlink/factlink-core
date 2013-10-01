module Util
  module Validations
    def validate_string_length param_name, param, length
      if param.length > length
        errors.add param_name,
          "should not be longer than #{length} characters."
      end
    end

    def validate_non_empty_list param_name, param
      unless param.respond_to? :each
        errors.add param_name, 'should be a list'
        return
      end
      unless param.length > 0
        errors.add param_name, 'should not be empty'
        return
      end
    end

    def validate_non_empty_list param_name, param
      unless param.respond_to? :each
        errors.add param_name, 'should be a list'
        return
      end
      unless param.length > 0
        errors.add param_name, 'should not be empty'
      end
    end
  end
end
