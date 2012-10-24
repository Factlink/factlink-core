module KillObject
  def self.conversation alive_object, extra_fields={}
    kill alive_object, [:id, :fact_data_id, :fact_id, :recipients_ids], extra_fields
  end

  def self.kill alive_object, take_fields, extra_fields={}
    hash = {}
    take_fields.each do |key|
      hash[key] = alive_object.send(key) if alive_object.respond_to? key
    end
    Hashie::Mash.new(hash.merge extra_fields)
  end
end
