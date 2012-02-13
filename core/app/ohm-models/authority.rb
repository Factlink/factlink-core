class Authority < OurOhm
  generic_reference :subject
  reference :user, GraphUser

  attribute :label
  index :label

  attribute :authority

  class << self
    def related(label, subject, opts={})
      if subject.is_a?(Hash)
        subject = Kernel.const_get(subject.keys[0])[subject.values[0]]
      end

      return Authority.new if subject.new?

      if opts[:for]
        find( label: label, subject_id: subject.id.to_s, subject_class: subject.class.to_s,
              user_id: opts[:for].id).first ||
            Authority.new(label: label, subject: subject, user: opts[:for])
      else
        find( label: label, subject_id: subject.id.to_s, subject_class: subject.class.to_s).first || Authority.new(label: label, subject: subject)
      end
    end
    
    def from(subject, opts={})
      related(:from, subject, opts)
    end

    def on(subject, opts={})
      related(:on, subject, opts)
    end

    def calculate_from klass, opts={}, &block
      calculators[klass.to_s] = block
    end

    def all_related(label, subject)
      find(label: label, subject_id: subject.id.to_s, subject_class: subject.class.to_s)
    end

    def all_from(subject)
      all_related(:from, subject)
    end

    def all_on(subject)
      all_related(:on, subject)
    end

    def calculated_from_authority(subject)
      calculators[subject.class.to_s].call subject
    end

    def recalculate_from subject
      from(subject) << calculated_from_authority(subject)
    end

    def reset_calculators
      @map_reducers = nil
      @calculators = Hash.new(lambda {|obj| 0.0})
    end

    #new system with mapreduce:
    def calculation=(map_reducers)
      @map_reducers = map_reducers
    end

    def run_calculation
      @map_reducers.andand.each do |mr|
        mr.process_all
      end
    end

    private
      def calculators
        @calculators ||= reset_calculators
      end
  end

  def << auth
    self.authority = auth
    save
  end

  def to_f
    (authority||0).to_f
  end

  def to_s
    sprintf('%.1f', to_f)
  end
end
