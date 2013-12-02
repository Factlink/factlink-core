class Authority < OurOhm
  generic_reference :subject
  reference :user, GraphUser

  attribute :label
  index :label

  attribute :authority

  class << self
    def debug x
      return unless @logger
      @logger.info "#{Time.now} #{x}"
      $stdout.flush
    end

    def logger= logger
      @logger = logger
    end

    def related(label, subject, opts={})
      AuthorityObject.by_reference self.key+"NEW", label,
        class_for(subject), subject.id.to_s,
        opts[:for] && opts[:for].id
    end

    def from(subject, opts={})
      related(:from, subject, opts)
    end

    def on(subject, opts={})
      related(:on, subject, opts)
    end

    def all_related(label, subject)
      return AuthorityObject.all_for self.key+"NEW", label,
        class_for(subject), subject.id.to_s
    end

    def all_from(subject)
      all_related(:from, subject)
    end

    def all_on(subject)
      all_related(:on, subject)
    end

    private
    def class_for object
      if object.respond_to? :acts_as_class_for_authority
        object.acts_as_class_for_authority
      else
        object.class.to_s
      end
    end
  end

  def << auth
    self.authority = auth
    save
  end

  def to_f
    (authority||0).to_f
  end

  def to_s(offset=0)
    sprintf('%.1f', to_f+offset)
  end
end

# we do this ourselves, since retrieval and setting with ohm takes to many
# operations, get should be 1, get should be 1, period.
class AuthorityObject
  def initialize(key, index)
    @key = key
    @index = index
  end

  def self.by_reference(basekey, type, subject_class, subject_id, user_id=nil)
    key = key_for(basekey, type, subject_class, subject_id, user_id)
    index =  index_key_for(basekey, type, subject_class, subject_id)
    new key, index
  end

  def new?
    false
  end

  def to_f
    @key.get.to_f
  end

  def to_s(offset=0)
    sprintf('%.1f', to_f+offset)
  end

  def << auth
    @key.set auth
    @index.sadd @key.to_s
  end

  def key
    @key
  end

  def == other
    self.key == other.key
  end

  def self.all_for(basekey, type, subject_class, subject_id)
    @index = index_key_for(basekey, type, subject_class, subject_id)
    res = @index.smembers.map { |key| AuthorityObject.new(Nest.new(key, Ohm.redis), @index)}
    res.class.send(:define_method,:all) { return self }
    res
  end

  def self.key_for(basekey, type, subject_class, subject_id, user_id)
    key = basekey + type + subject_class + subject_id
    key += user_id ? user_id : 'nil'
    key
  end

  def subject
    klassname,id = @key.split('+')[-3..-2]
            #constantize
    klass = klassname.split('::').inject(Kernel) {|x,y|x.const_get(y)}
    klass[id]
  end

  def user_id
    id = @key.split('+')[-1]
    id == 'nil' ? nil : id
  end

  def user
    user_id && GraphUser[user_id]
  end

  def self.index_key_for(basekey, type, subject_class, subject_id)
    basekey + "LIST" + type + subject_class + subject_id
  end

end
