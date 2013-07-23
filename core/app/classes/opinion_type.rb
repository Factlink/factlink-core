class OpinionType
  def self.real_for type
    case type.to_s
    when 'beliefs', 'believes'       then :believes
    when 'doubts'                    then :doubts
    when 'disbeliefs', 'disbelieves' then :disbelieves
    else raise "invalid opinion"
    end
  end

  def self.for_relation_type type
    case type.to_s
    when 'supporting' then :believes
    when 'weakening'  then :disbelieves
    end
  end

  def self.types
    [:believes, :doubts, :disbelieves]
  end
end
