require 'ohm/contrib'

class Activity < OurOhm
  include Ohm::Timestamping
  reference :user, GraphUser
  
  attribute :subject_id
  attribute :subject_class

  #TODO opruimen

  def self.generic_reference(name)
    reader = :"#{name}_id"
    writer = :"#{name}_id="

    reader_c = :"#{name}_class"
    writer_c = :"#{name}_class="

    attributes(self) << reader   unless attributes.include?(reader)
    attributes(self) << reader_c unless attributes.include?(reader_c)

    index reader
    index reader_c

    define_memoized_method(name) do
      klass = Kernel.const_get(send(reader_c))
      if klass == NilClass
        return nil
      else
        return klass[send(reader)]
      end
    end

    define_method(:"#{name}=") do |value|
      @_memo.delete(name)
      send(writer, value ? value.id : nil)
      send(writer_c, value ? value.class : nil)
    end

    define_method(reader) do
      read_local(reader)
    end

    define_method(writer) do |value|
      @_memo.delete(name)
      write_local(reader, value)
    end

    define_method(reader_c) do
      read_local(reader_c)
    end

    define_method(writer_c) do |value|
      @_memo.delete(name)
      write_local(reader_c, value)
    end
  end

  # generic_reference subject  
  index :subject_id
  index :subject_class
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
  
  # generic_reference object
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