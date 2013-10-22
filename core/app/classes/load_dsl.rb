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
    u = @state_user
    unless u
      raise UndefinedUserError, "A user was needed but wasn't found", caller
    end
    u.graph_user
  end

  attr_writer :state_user, :state_channel
  attr_accessor :state_fact

  def state_channel
    @state_channel || self.load_channel(self.state_graph_user,"Main channel")
  end

  def load_site(url)
    Site.find(:url => url).first || Site.create(:url => url)
  end

  def load_fact(fact_string,url="http://example.org/", opts={})
    f = Fact.by_display_string(fact_string)
    return f if f

    f = Fact.create(
      :site => load_site(url),
      :created_by => state_graph_user
    )
    f.require_saved_data
    f.data.displaystring = fact_string
    f.data.title = opts[:title] || url
    f.data.save

    f
  end

  def fact(fact_string,url="http://example.org/", opts={})
    f = self.load_fact(fact_string,url, opts)
    self.state_fact = f
  end

  def fact_relation(fact1,relation,fact2)
    f1 = self.fact(fact1)
    f2 = self.fact(fact2)
    fr = f2.add_evidence(relation,f1,state_graph_user)
    self.state_fact = fr
  end

  def raise_undefined_user_error
    raise UndefinedUserError, "A new user was introduced, but email and password were not given", caller
  end

  def raise_error_if_not_saved u
    return unless u.new_record?

    err_msg = "User #{username} could not be created."
    u.errors.each { |e, v| err_msg += "\n#{e.to_s} #{v}" }
    raise err_msg
  end

  def load_user(username, email=nil, password=nil, full_name=nil)
    u = User.where(:username => username).first
    return u if u
    raise_undefined_user_error unless email and password

    u = User.new(
      :username => username,
      :password => password,
      :password_confirmation => password,
      :full_name => full_name || username )
    u.agrees_tos = true
    u.agreed_tos_on = DateTime.now
    u.email = email
    u.confirmed_at = DateTime.now
    u.save

    raise_error_if_not_saved(u)
    HandpickedTourUsers.new.add u.id

    u
  end

  def user(username, email=nil, password=nil, full_name=nil)
    self.state_user = self.load_user(username, email, password, full_name)
  end

  def believers(*l)
    self.set_opinion(:believes, *l)
  end

  def disbelievers(*l)
    self.set_opinion(:disbelieves, *l)
  end

  def doubters(*l)
    self.set_opinion(:doubts, *l)
  end

  def set_opinion(opinion_type, *users)
    f = state_fact
    users.each do |username|
      gu = self.load_user(username).graph_user
      f.add_opinion opinion_type, gu
    end
  end

  def load_channel(graph_user, title, opts={})
    ch = ChannelList.new(graph_user).channels.find(:title => title).first

    ch || Channel.create(:created_by => graph_user, :title => title)
  end

  def channel(title, opts={})
    ch = self.load_channel(state_graph_user, title, opts)
    self.state_channel = ch
  end

  def sub_channel(username,title, opts={})
    ch = self.load_channel(load_user(username).graph_user, title, opts)
    command :'channels/add_subchannel', channel: state_channel, subchannel: ch
  end

  def add_fact(fact_string)
    fact = self.load_fact(fact_string)

    interactor :'channels/add_fact', fact: fact, channel: state_channel
  end

  def run(&block)
    instance_eval(&block)
  end
end
