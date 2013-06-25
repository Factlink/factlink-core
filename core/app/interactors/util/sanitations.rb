module Util
  module Sanitations
    def sanitize_boolean_hash name
      hash = {}
      instance_variable_get("@#{name}").each do |key, value|
        hash[key.to_sym] = !!value
      end
      instance_variable_set "@#{name}", hash
    end
  end
end
