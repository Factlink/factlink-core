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

  def calculate_impact(truth_opinion, relevance_opinion)
    result = self.discount_by(truth_opinion).discount_by(relevance_opinion)

    result.a = [truth_opinion.a, relevance_opinion.a].min

    result
  end

  def ==(other)
    self.a == other.a and
      self.b == other.b and
      self.d == other.d and
      self.u == other.u
  end

  protected

  def discount_by(other)
    b = self.b * other.b
    d = self.d * other.b
    u = other.d + other.u + self.u * other.b

    Opinion.tuple(b, d, u, a)
  end
end
