require 'ohm/contrib'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser
  
  generic_reference :subject
  generic_reference :object

  attribute :action
  
  def self.for(search_for)
    res = find(subject_id: search_for.id, subject_class: search_for.class) | find(object_id: search_for.id, object_class: search_for.class)
    if search_for.class == GraphUser
      res |= find(user_id: search_for.id)
    end
    res
  end
end

module ActivitySubject
  
  def activity(user, action, subject, sub_action = :to ,object = nil)
    Activity.create(user: user,action: action, subject: subject, object: object)
  end

  def activities
    Activity.for(self).sort_by(:created_at)
  end

end