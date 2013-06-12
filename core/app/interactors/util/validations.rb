module Util
  module Validations
    def validate_string_length param_name, param, length
      if param.length > length
        raise Pavlov::ValidationError,
          "#{param_name.to_s} should not be longer than #{length} characters."
      end
    end
  end
end
