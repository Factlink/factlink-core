require 'active_support/core_ext/hash/slice'

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

    # TODO : bit fragile
    def self.empty_activity_set
      Ohm::Model::Set.new(Ohm::Model.key[:emptyset], Ohm::Model::Wrapper.new(:Activity) {Activity})
    end

    def self.where(queries)
      return empty_activity_set if queries.length == 0

      queries.map {|q| where_one(q)}.reduce {|res, set| res | set}
    end

    def self.where_one(query)
      return empty_activity_set if query.slice(:user, :action, :subject, :object) == {}

      set = Activity.all
      set = set.find(   user_id: query[:user].id )                                          if query[:user]
      set = set.find(subject_id: query[:subject].id, subject_class: query[:subject].class ) if query[:subject]
      set = set.find( object_id: query[:object].id,   object_class: query[:object].class )  if query[:object]
      set = set.find(    action: query[:action].to_s)                                       if query[:action]
      set
    end
  end
end
