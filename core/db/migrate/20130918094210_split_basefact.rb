class SplitBasefact < Mongoid::Migration
  def self.up
    puts "Running split basefact up"
    base_sets = %w"people_believes people_disbelieves people_doubts"
    fact_sets = base_sets + %w"channels supporting_facts weakening_facts"
    fr_sets = base_sets
    fact_props = %w"site_id data_id created_by_id"
    fr_props = %w"from_fact_id fact_id created_by_id created_at updated_at type"
    combos = [[Fact,fact_props,fact_sets],[FactRelation,fr_props, fr_sets]]

    db = Redis.current
    combos.each do |klass, props, sets|
      klass.all.ids.each do |obj_id|
        old_hash_name = "Basefact:#{obj_id}"
        new_hash_name = "#{klass.name}:#{obj_id}"
        raise "cannot find old hash (#{old_hash_name})" if !db.exists(old_hash_name)
        raise "new hash already exists (#{new_hash_name})" if db.exists(new_hash_name)
        obj = klass[obj_id]

        old_hash = db.hgetall old_hash_name
        extra_hash_keys = old_hash.keys - props - ["_type"]
        if extra_hash_keys.size>0
          raise "extraneous hash keys for #{new_hash_name}: #{extra_hash_keys.inspect}"
        end

        props.each do |prop|
          obj.send(prop+'=', old_hash[prop])
        end

        sets.each do |set_name|
          old_set_name = "Basefact:#{obj.id}:#{set_name}"
          new_set_name = "#{klass.name}:#{obj.id}:#{set_name}"
          if db.exists(old_set_name)
            raise "Key already migrated?" if db.exists(new_set_name)
            db.rename(old_set_name, new_set_name)
          end
          obj.send(set_name).size #make sure we touch the set in ohm.
        end

        obj.save
        raise "new hash not created: bug!" if !db.exists(new_hash_name)
        db.del old_hash_name
      end
    end
  end

  def self.down
    raise "down unsupported!"
  end
end
