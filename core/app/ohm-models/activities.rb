require 'ohm/contrib'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser
  attribute :subject_id
  attribute :subject_class
  def subject=(value)
    self.subject_id=value.id
    self.subject_class=value.class
  end
  def subject
    return Kernel.const_get(self.subject_class)[self.subject_id]
  end
  attribute :subject_id
  attribute :subject_class
  def subject=(value)
    self.subject_class=value.class
    self.subject_id=value.id unless value == nil
  end

  def subject
    klass = Kernel.const_get(self.subject_class)
    if klass == NilClass
      return nil
    else
      return klass[self.subject_id]
    end
  end
  
  attribute :object_class
  attribute :object_id
  def object=(value)
    self.object_class=value.class
    self.object_id=value.id unless value == nil
  end
  def object
    klass = Kernel.const_get(self.object_class)
    if klass == NilClass
      return nil
    else
      return klass[self.object_id]
    end
  end
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