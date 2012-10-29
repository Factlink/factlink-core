module Pavlov
  module Validations
    def validate_hexadecimal_string param_name, param
      raise "#{param_name.to_s} should be an hexadecimal string." unless /\A[\da-fA-F]+\Z/.match param
    end

    def validate_regex param_name, param, regex, message
      raise "#{param_name.to_s} #{message}" unless regex.match param
    end
  end
end
