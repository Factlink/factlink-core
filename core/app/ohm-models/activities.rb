require 'ohm/contrib'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser
  
  generic_reference :subject
  generic_reference :object

  attribute :action
  
  def self.for(search_for)
    if search_for.class == GraphUser
      find(user_id: search_for.id)
    else
      find(subject_id: search_for.id, subject_class: search_for.class)
    end
  end
end

module ActivitySubject
  
  def activity(user, action, subject, sub_action = :to ,object = nil)
    Activity.create(
      :user => user,
      :action => action,
      :subject => subject,
      :object => object
    )
  end

end