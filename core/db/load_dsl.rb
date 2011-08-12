class LoadDslState
  @@user = nil
  @@fact = nil

  def self.graph_user
    @@user.graph_user || User.all.first.graph_user
  end

  def self.user=(value)
    @@user = value
  end
  
  def self.fact=(value)
    @@fact = value
  end
  
  def self.fact
    @@fact
  end
end

def load_fact(fact_string,url="http://example.org/")
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

def fact(fact_string,url="http://example.org/")
  f = load_fact(fact_string,url)
  LoadDslState.fact = f
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


def load_user(username,email=nil, password=nil)
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
  u
end

def user(username,email=nil, password=nil)
  LoadDslState.user = load_user(username,email,password)
end

def export_user(graph_user)
  "user \"#{quote_string(graph_user.username)}\", \"#{quote_string(graph_user.user.email)}\"\n"
end


def believers(*l)
  set_opinion(:beliefs,*l)
end
def disbelievers(*l)
  set_opinion(:disbeliefs,*l)
end
def doubters(*l)
  set_opinion(:doubts,*l)
end


def export_userlist(l)
  l.map {|graph_user| "\"#{quote_string(graph_user.user.username)}\""}.join(',')
end
def export_believers(l)
  rv = "believers " + export_userlist(l) + "\n"
end
def export_disbelievers(l)
  rv = "disbelievers " + export_userlist(l) + "\n"
end
def export_doubters(l)
  rv = "doubters " + export_userlist(l) + "\n"
end

def set_opinion(opinion_type,*users)
  f = LoadDslState.fact
  users.each do |username|
    u = load_user(username)
    f.add_opinion(opinion_type,u)
  end
end


def quote_string(v)
  v.to_s.gsub(/\\/, '\&\&').gsub(/"/, "\\\"")
end

