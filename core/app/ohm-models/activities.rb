require 'ohm/contrib'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser
  
  attribute :subject_id
  attribute :subject_class

  generic_reference :subject
  generic_reference :object

  attribute :action
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