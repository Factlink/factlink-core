module Pavlov
  module Validations
    def validate_hexadecimal_string paramname, param
      raise "#{paramname.to_s} should be an hexadecimal string." unless /\A[\da-fA-F]+\Z/.match param
    end
  end
end
