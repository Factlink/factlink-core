class UndefinedUserError < StandardError
end


def load_fact_data(&block)
  LoadDsl.new.run(&block)
end

class LoadDsl

  def state_graph_user
    u = @user
    unless u
      raise UndefinedUserError, "A user was needed but wasn't found", caller
    end
    u.graph_user
  end

  def state_user=(value)
    @user = value
  end

  def state_fact=(value)
    @fact = value
  end

  def state_fact
    @fact
  end

  def state_channel
    @channel || self.load_channel(self.state_graph_user,"Main channel")
  end

  def state_channel=(value)
    @channel = value
  end

  def load_fact(fact_string,url="http://example.org/")
    f = Fact.by_display_string(fact_string)
    if not f
      f = Fact.create(
      :site => Site.find_or_create_by(:url => url),
      :created_by => state_graph_user
      )
      f.data.displaystring = fact_string
      f.data.save
    end
    f
  end

  def fact(fact_string,url="http://example.org/")
    f = self.load_fact(fact_string,url)
    self.state_fact = f
  end

  def self.export_fact(fact)
    rv = "fact \"#{quote_string(fact.displaystring)}\""
    rv += ", \"#{fact.site.url}\"\n" if fact.site
    rv
  end

  def fact_relation(fact1,relation,fact2)
    f1 = self.fact(fact1)
    f2 = self.fact(fact2)
    fr = f2.add_evidence(relation,f1,state_graph_user)
    self.state_fact = fr
  end

  def self.export_fact_relation(fact_relation)
    "fact_relation \"#{quote_string(fact_relation.get_from_fact.displaystring)}\", :#{fact_relation.type.to_sym}, \"#{quote_string(fact_relation.get_to_fact.displaystring)}\"\n"
  end


  def load_user(username,email=nil, password=nil)
    u = User.where(:username => username).first
    if not u
      if email and password
        u = User.create(:username => username,
        :email => email,
        :confirmed_at => DateTime.now,
        :password => password,
        :password_confirmation => password)
      else
        raise UndefinedUserError, "A new user was introduced, but email and password were not given", caller
      end
    end
    u
  end

  def user(username,email=nil, password=nil)
    self.state_user = self.load_user(username,email,password)
  end

  def self.export_user(graph_user)
    "user \"#{quote_string(graph_user.username)}\", \"#{quote_string(graph_user.user.email)}\", \"123hoi\"\n"
  end

  def self.export_activate_user(graph_user)
    "user \"#{quote_string(graph_user.username)}\"\n"
  end


  def believers(*l)
    self.set_opinion(:beliefs,*l)
  end
  def disbelievers(*l)
    self.set_opinion(:disbeliefs,*l)
  end
  def doubters(*l)
    self.set_opinion(:doubts,*l)
  end


  def self.export_userlist(l)
    l.map {|graph_user| "\"#{quote_string(graph_user.user.username)}\""}.join(',')
  end
  def self.export_believers(l)
    rv = "believers " + export_userlist(l) + "\n"
  end
  def self.export_disbelievers(l)
    rv = "disbelievers " + export_userlist(l) + "\n"
  end
  def self.export_doubters(l)
    rv = "doubters " + export_userlist(l) + "\n"
  end

  def set_opinion(opinion_type,*users)
    f = state_fact
    users.each do |username|
      gu = self.load_user(username).graph_user
      f.add_opinion(opinion_type,gu)
    end
  end

  def load_channel(graph_user, title)
    graph_user.channels.find(:title => title).first || Channel.create(:created_by => graph_user, :title => title)
  end

  def channel(title)
    ch = self.load_channel(state_graph_user, title)
    self.state_channel = ch
  end

  def self.export_channel(channel)
    "channel \"#{quote_string(channel.title)}\"\n"
  end

  def sub_channel(username,title)
    ch = self.load_channel(load_user(username).graph_user, title)
    self.state_channel.add_channel(ch)
  end

  def self.export_sub_channel(channel)
    "sub_channel \"#{quote_string(channel.created_by.username)}\", \"#{quote_string(channel.title)}\"\n"
  end

  def add_fact(fact_string)
    f = self.load_fact(fact_string)
    self.state_channel.add_fact(f)
  end

  def self.export_add_fact(fact)
    "add_fact \"#{quote_string(fact.displaystring)}\"\n"
  end

  def del_fact(fact_string)
    f = self.load_fact(fact_string)
    self.state_channel.remove_fact(f)
  end

  def self.export_del_fact(fact)
    "del_fact \"#{quote_string(fact.displaystring)}\"\n"
  end


  def self.quote_string(v)
    v.to_s.gsub(/\\/, '\&\&').gsub(/"/, "\\\"")
  end

  def self.export_header
    "# coding: utf-8\n\nload_fact_data do\n\n"
  end
  def self.export_footer
    "end"
  end

  def run(&block)
    instance_eval &block
  end

end