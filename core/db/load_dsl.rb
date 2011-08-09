class LoadDslState
  def self.graph_user
    @@user.graph_user || User.all.first.graph_user
  end

  def self.user=(value)
    @@user = value
  end
end

def fact(fact_string,url="http://example.org/")
  f = Fact.by_display_string(fact_string)
  if not f
    f = Fact.new
    f.displaystring = fact_string
    f.site = Site.find_or_create_by(url)
    f.created_by = LoadDslState.graph_user
    f.save
  end
  f
end

def export_fact(fact)
  "fact \"#{quote_string(fact.displaystring)}\", \"#{fact.site.url}\"\n"
end

def fact_relation(fact1,relation,fact2)
  f1 = fact(fact1)
  f2 = fact(fact2)

  f2.add_evidence(relation,f1,LoadDslState.graph_user)
end

def export_fact_relation(fact_relation)
  "fact_relation \"#{quote_string(fact_relation.get_from_fact.displaystring)}\", :#{fact_relation.type.to_sym}, \"#{quote_string(fact_relation.get_to_fact.displaystring)}\"\n"
end


def user(username,email=nil, password=nil)
  u = User.where(:username => username).first
  if not u
    mail ||= "#{username}@example.org"
    password ||= "123hoi"
    u = User.new(:username => username,
    :email => email,
    :confirmed_at => DateTime.now,
    :password => password,
    :password_confirmation => password)
    u.save
  end
  LoadDslState.user = u
end

def beliefs(fact_string)
  set_opinion(:beliefs,fact_string)
end

def disbeliefs(fact_string)
  set_opinion(:disbeliefs,fact_string)
end

def doubts(fact_string)
  set_opinion(:doubts,fact_string)
end

def set_opinion(opinion_type,fact_string)
  gu = LoadDslState.graph_user
  f = fact(fact_string)
  f.add_opinion(opinion_type,gu)
end


def quote_string(v)
  v.to_s.gsub(/\\/, '\&\&').gsub(/"/, "\\\"")
end

