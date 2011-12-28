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

    def self.where(queries)
      return Ohm::Model::Set.new(Ohm::Model.key[:emptyset], Ohm::Model::Wrapper.new(:Activity) {Activity}) if queries.length == 0

      queries.map {|q| where_one(q)}.reduce {|res, set| res | set}
    end

    def self.where_one(query)
      set = Activity.all()
      #set = set.find(user_id: query[:user].id ) if query[:user]
      set
    end
  end
end
