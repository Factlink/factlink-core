class Authority < OurOhm
  generic_reference :subject

  attribute :authority

  def self.from(search_for)
    find(subject_id: search_for.id.to_s, subject_class: search_for.class.to_s).first || Authority.new
  end

  def to_f
    (authority||1).to_f
  end

  def to_s
    sprintf('%.1f', to_f)
  end
end
