class Authority < OurOhm
  generic_reference :subject
  reference :user, GraphUser

  attribute :authority

  class << self
    def from(subject, opts={})
      if opts[:for]
        find( subject_id: subject.id.to_s, subject_class: subject.class.to_s,
              user_id: opts[:for].id).first ||
            Authority.new(subject: subject, user: opts[:for])
      else
        find( subject_id: subject.id.to_s, subject_class: subject.class.to_s).first || Authority.new(subject: subject)
      end
    end

    def calculate_from klass, &block
      calculators[klass.to_s] = block
    end

    def calculated_from_authority(subject)
      calculators[subject.class.to_s].call subject
    end

    def recalculate_from subject
      from(subject) << calculated_from_authority(subject)
    end

    def reset_calculators
      @calculators = Hash.new(lambda {|obj| 0.0})
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
