module Util
  module Validations
    def validate_string_length param_name, param, length
      if param.length > length
        errors.add param_name,
          "should not be longer than #{length} characters."
      end
    end
  end
end
