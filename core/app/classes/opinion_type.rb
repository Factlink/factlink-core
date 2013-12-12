module OpinionType
  def self.types
    @types ||= ['believes', 'disbelieves', 'doubts'].freeze
  end

  def self.include?(type)
    types.include?(type.to_s)
  end
end
