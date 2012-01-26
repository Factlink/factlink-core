class Authority < OurOhm
  generic_reference :subject

  attribute :authority

  class << self
    def from(search_for)
      find(subject_id: search_for.id.to_s, subject_class: search_for.class.to_s).first ||
        Authority.new(subject: search_for)
    end

    def set_from(subject, authority)
      a = from(subject)
      a.authority = authority
      a.save
    end

    def calculate_from klass, &block
      calculators[klass.to_s] = block
    end

    def calculated_from_authority(subject)
      calculators[subject.class.to_s].call subject
    end

    def recalculate_from subject
      set_from subject, calculated_from_authority(subject)
    end

    def reset_calculators
      @calculators = Hash.new(lambda {|obj| 1})
    end

    private
      def calculators
        @calculators ||= reset_calculators
      end
 end

  def to_f
    (authority||1).to_f
  end

  def to_s
    sprintf('%.1f', to_f)
  end
end
