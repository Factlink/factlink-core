class LoadDsl
  include Pavlov::Helpers

  def pavlov_options
    { no_current_user: true }
  end

  class UndefinedUserError < StandardError;end

  def self.load(&block)
    new.run(&block)
  end

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

  def load_site(url)
    Site.find(:url => url).first || Site.create(:url => url)
  end

  def site(url)
    load_site(url)
  end

  def self.export_site(site)
    rv = "site \"#{quote_string(site.url)}\""
    rv += "\n"
    rv
  end

  def load_fact(fact_string,url="http://example.org/", opts={})
    f = Fact.by_display_string(fact_string)
    if not f
      f = Fact.create(
        :site => load_site(url),
        :created_by => state_graph_user
      )
      f.require_saved_data
      f.data.displaystring = fact_string
      f.data.title = opts[:title] if opts[:title]
      f.data.save
    end
    f
  end

  def fact(fact_string,url="http://example.org/", opts={})
    f = self.load_fact(fact_string,url, opts)
    self.state_fact = f
  end

  def self.export_fact(fact)
    rv = "fact \"#{quote_string(fact.data.displaystring)}\""
    rv += ", \"#{quote_string(fact.site.url)}\"" if fact.site
    rv += ", :title => \"#{quote_string(fact.data.title)}\"" if fact.data.title
    rv += "\n"
    rv
  end

  def fact_relation(fact1,relation,fact2)
    f1 = self.fact(fact1)
    f2 = self.fact(fact2)
    fr = f2.add_evidence(relation,f1,state_graph_user)
    self.state_fact = fr
  end

  def self.export_fact_relation(fact_relation)
    "fact_relation \"#{quote_string(fact_relation.from_fact.data.displaystring)}\", :#{fact_relation.type.to_sym}, \"#{quote_string(fact_relation.fact.data.displaystring)}\"\n"
  end

  def load_user(username,email=nil, password=nil, twitter=nil)
    u = User.where(:username => username).first
    if not u
      if email and password
        u = User.new(
          :username => username,
          :password => password,
          :password_confirmation => password,
          :twitter => twitter)
        u.approved = true
        u.agrees_tos = true
        u.agreed_tos_on = DateTime.now
        u.email = email
        u.confirmed_at = DateTime.now
        u.save
        u.send(:create_graph_user) {}
        if u.new?
          err_msg = "User #{username} could not be created."
          u.errors.each { |e, v| err_msg += "\n#{e.to_s} #{v}" }
          raise err_msg if u.new?
        end
      else
        raise UndefinedUserError, "A new user was introduced, but email and password were not given", caller
      end
    end
    u
  end

  def user(username,email=nil, password=nil, twitter=nil)
    self.state_user = self.load_user(username,email,password,twitter)
  end

  def self.export_user(graph_user)
    rv = "user \"#{quote_string(graph_user.user.username)}\", \"#{quote_string(graph_user.user.email)}\", \"123hoi\""
    rv += ", \"#{graph_user.user.twitter}\"" if graph_user.user.twitter and graph_user.user.twitter != ''
    rv += "\n"
  end

  def self.export_activate_user(graph_user)
    "user \"#{quote_string(graph_user.user.username)}\"\n"
  end

  def believers(*l)
    self.set_opinion(:believes,*l)
  end

  def disbelievers(*l)
    self.set_opinion(:disbelieves,*l)
  end

  def doubters(*l)
    self.set_opinion(:doubts,*l)
  end

  def self.export_userlist(l)
    l.map {|graph_user| "\"#{quote_string(graph_user.user.username)}\""}.join(',')
  end

  def self.export_believers(l)
    "believers " + export_userlist(l) + "\n"
  end

  def self.export_disbelievers(l)
    "disbelievers " + export_userlist(l) + "\n"
  end

  def self.export_doubters(l)
    "doubters " + export_userlist(l) + "\n"
  end

  def set_opinion(opinion_type,*users)
    f = state_fact
    users.each do |username|
      gu = self.load_user(username).graph_user
      f.add_opinion opinion_type, gu
    end
  end

  def load_channel(graph_user, title, opts={})
    ch = ChannelList.new(graph_user).channels.find(:title => title).first
    unless ch
      ch = Channel.create(:created_by => graph_user, :title => title)
    end
    ch
  end

  def channel(title, opts={})
    ch = self.load_channel(state_graph_user, title, opts)
    self.state_channel = ch
  end

  def self.export_channel(channel)
    rv = "channel \"#{quote_string(channel.title)}\""
    rv += "\n"
  end

  def sub_channel(username,title, opts={})
    ch = self.load_channel(load_user(username).graph_user, title, opts)
    self.state_channel.add_channel(ch)
  end

  def self.export_sub_channel(channel)
    rv = "sub_channel \"#{quote_string(channel.created_by.user.username)}\", \"#{quote_string(channel.title)}\""
    rv += "\n"
  end

  def add_fact(fact_string)
    fact = self.load_fact(fact_string)

    interactor :'channels/add_fact', fact, self.state_channel
  end

  def self.export_add_fact(fact)
    "add_fact \"#{quote_string(fact.data.displaystring)}\"\n"
  end

  def del_fact(fact_string)
    f = self.load_fact(fact_string)
    self.state_channel.remove_fact(f)
  end

  def self.export_del_fact(fact)
    "del_fact \"#{quote_string(fact.data.displaystring)}\"\n"
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
    instance_eval(&block)
  end
end
