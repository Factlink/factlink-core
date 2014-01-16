class LoadDsl
  include Pavlov::Helpers

  def pavlov_options
    { current_user: @state_user }
  end

  class UndefinedUserError < StandardError;end

  def self.load(&block)
    new.run(&block)
  end

  def state_graph_user
    u = @state_user
    unless u
      fail UndefinedUserError, "A user was needed but wasn't found", caller
    end
    u.graph_user
  end

  attr_writer :state_user

  def load_site(url)
    Site.find(:url => url).first || Site.create(:url => url)
  end

  def load_fact(fact_string,url="http://example.org/", opts={})
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

  def fact(fact_string,url="http://example.org/", opts={}, &block)
    f = load_fact(fact_string,url, opts)
    FactDsl.new(f).instance_eval(&block) if block_given?
  end

  def raise_undefined_user_error
    fail UndefinedUserError, "A new user was introduced, but email and password were not given", caller
  end

  def raise_error_if_not_saved u
    return unless u.new_record?

    err_msg = "User #{username} could not be created."
    u.errors.each { |e, v| err_msg += "\n#{e.to_s} #{v}" }
    fail err_msg
  end

  def user(username, email=nil, password=nil, full_name=nil)
    raise_undefined_user_error unless email and password

    u = User.new(
      :username => username,
      :password => password,
      :password_confirmation => password,
      :full_name => full_name || username )
    u.email = email
    u.confirmed_at = DateTime.now
    u.set_up = true
    u.admin = true
    u.seen_tour_step = 'tour_done'
    u.save

    raise_error_if_not_saved(u)
    HandpickedTourUsers.new.add u.id

    u
  end

  def as_user(username)
    self.state_user = User.where(:username => username).first
  end

  def run(&block)
    instance_eval(&block)
  end
end
