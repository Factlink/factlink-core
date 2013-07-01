require_relative 'opinion/subject.rb'

class Opinion < OurOhm
  # naming conventions as in the document describing the calculations
  # b = belief
  # d = disbeliefs
  # u = uncertain
  #
  # a = authority
  #
  # _r in redis

  attribute :b_r
  attribute :d_r
  attribute :u_r
  attribute :a_r

  def b
    self.b_r.to_f
  end

  def d
    self.d_r.to_f
  end

  def u
    self.u_r.to_f
  end

  def a
    self.a_r.to_f
  end

  alias :b= :b_r=
  alias :d= :d_r=
  alias :u= :u_r=
  alias :a= :a_r=

  alias :authority :a
  alias :beliefs :b
  alias :disbeliefs :d
  alias :doubts :u

  def take_values(other)
    self.a = other.a
    self.b = other.b
    self.d = other.d
    self.u = other.u
    save
  end

  def self.tuple(b, d, u, a=0)
    new(b_r: b, d_r: d, u_r: u, a_r: a)
  end

  def self.identity
    tuple(0, 0, 1, 0)
  end

  def self.for_type(type, authority=0)
    case type
    when :believes
      tuple(1, 0, 0, authority)
    when :disbelieves
      tuple(0, 1, 0, authority)
    when :doubts
      tuple(0, 0, 1, authority)
    end
  end

  # inefficient, but allows for quickly changing the + def
  def self.combine(list)
    list.reduce(Opinion.identity, :+)
  end

  # CHANGE ALONG WITH + !!!!
  def weight
    (self.b + self.d + self.u)*self.a
  end

  # CHANGE weight ALONG WITH + !!!
  def +(other)
    a = self.a + other.a
    return Opinion.identity if a == 0

    b = (self.b*self.a + other.b*other.a)/a
    d = (self.d*self.a + other.d*other.a)/a
    u = (self.u*self.a + other.u*other.a)/a

    Opinion.tuple(b, d, u, a)
  end

  # TODO : better name
  def dfa(fr, fl)
    result = self.discount_by(fr).discount_by(fl)

    result.a = [fr.a, fl.a].min
    return result
  end

  def ==(other)
    self.a == other.a and
      self.b == other.b and
      self.d == other.d and
      self.u == other.u
  end

  define_memoized_method :as_percentages do
    total = b + d + u

    l_believe_percentage = calc_percentage(total, b)
    l_disbelieve_percentage = calc_percentage(total, d)
    l_doubt_percentage = 100 - l_believe_percentage - l_disbelieve_percentage

    @percentage_hash = {
      believe:    { percentage: l_believe_percentage },
      disbelieve: { percentage: l_disbelieve_percentage },
      doubt:      { percentage: l_doubt_percentage  },
      # TODO this logic should go elsewhere, but only after letting the update_opinion and
      #     remove opinion build proper json (instead of fact.to_json)
      authority: friendly_authority
    }
  end

  def friendly_authority
    NumberFormatter.new(a).as_authority
  end

  def self.types
    [:believes, :doubts, :disbelieves]
  end

  def self.for_relation_type(type)
    case type.to_sym
    when :supporting
      Opinion.for_type(:believes)
    when :weakening
      Opinion.for_type(:disbelieves)
    end
  end

  def self.real_for(type)
    case type.to_sym
    when :beliefs, :believes       then :believes
    when :doubts                   then :doubts
    when :disbeliefs, :disbelieves then :disbelieves
    else raise "invalid opinion"
    end
  end

  protected

  def discount_by(other)
    b = self.b * other.b
    d = self.d * other.b
    u = other.d + other.u + self.u * other.b

    Opinion.tuple(b, d, u, a)
  end

  private

  def calc_percentage(total, part)
    if total > 0
      ((100 * part) / total).round.to_i
    else
      0
    end
  end
end
