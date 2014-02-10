require 'ostruct'

module KillObject
  def self.dead_object(name, fields)
    self.class.send(:define_method, name) do |*args|
      alive_object, extra_fields = *args
      kill name, alive_object, fields, extra_fields || {}
    end
  end

  dead_object :user,
    [:id, :name, :username, :location, :biography,
     :gravatar_hash, :email, :receives_mailed_notifications,
     :receives_digest, :graph_user_id, :statistics,
     :deleted, :hidden?, :confirmed?]

  def self.kill name, alive_object, take_fields, extra_fields={}
    hash = {dead_object_name: name}
    take_fields.each do |key|
      hash[key] = alive_object.send(key) if alive_object.respond_to? key
    end
    open_struct = OpenStruct.new(hash.merge extra_fields)

    open_struct.send(:define_singleton_method, :to_json) do |*args|
      table.to_json(*args)
    end

    open_struct
  end
end
