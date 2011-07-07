require 'redis'
require 'redis/objects'
Redis::Objects.redis = Redis.new

class Fact < Basefact
  include Redis::Objects

  set :supporting_facts
  set :weakening_facts

  scope :facts, where(:_type => "Fact")

  def evidence_count
    0
  end
  
  def union
    res = supporting_facts | weakening_facts
    res
  end
  
  def evidence(type)
    case type
    when :supporting
      supporting_facts
    when :weakening
      weakening_facts
    end
  end
  
  def add_evidence(type,factlink,user)
    factlink = Factlink.get_or_create(factlink,type,self,user)
    evidence(type) << factlink.id.to_s
  end
  
  # Used for sorting
  def self.column_names
    self.fields.collect { |field| field[0] }
  end

  def evidence_opinion
    opinions = []
    [:supporting, :weakening].each do |type|
      factlinks = Factlink.where(:_id.in => evidence(type).members)
      factlinks.each do |factlink|
        opinions << factlink.get_influencing_opinion
      end
    end    
    Opinion.combine(opinions)
  end

  def get_opinion
    user_opinion = super
    user_opinion + evidence_opinion
  end

end
