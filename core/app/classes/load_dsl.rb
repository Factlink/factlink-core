class LoadDsl
  def self.load(&block)
    new.run(&block)
  end

  def user(username, email, password, full_name)
    UserBuilder.new.build(username, email, password, full_name)
  end

  def as_user(username, &block)
    user = User.where(username: username).first
    UserDsl.new(user).instance_eval(&block) if block_given?
  end

  def run(&block)
    instance_eval(&block)
  end
end
