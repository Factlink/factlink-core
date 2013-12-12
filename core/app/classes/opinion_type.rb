module OpinionType
  def self.types
    @types ||= ['believes', 'disbelieves', 'doubts'].freeze
  end
end
