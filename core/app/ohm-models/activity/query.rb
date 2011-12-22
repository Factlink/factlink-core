class Activity < OurOhm
  module Query

    def self.for(search_for)
      res = find(subject_id: search_for.id, subject_class: search_for.class) | find(object_id: search_for.id, object_class: search_for.class)
      if search_for.class == GraphUser
        res |= find(user_id: search_for.id)
      end
      res
    end

    def self.find(*args)
      Activity.find *args
    end

  end
end
