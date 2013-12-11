class OpinionType
  def self.real_for type
    case type.to_s
    when 'beliefs', 'believes'       then :believes
    when 'doubts'                    then :doubts
    when 'disbeliefs', 'disbelieves' then :disbelieves
    else raise "invalid opinion"
    end
  end

  def self.types
    [:believes, :doubts, :disbelieves]
  end
end
