module PavlovSupport
  # DEPRECATED
  # Just use e.g. interactor.should_receive(:query).with(...)
  def should_receive_new_and_call(klass)
    klass_instance = mock()
    klass.should_receive(:new).and_return(klass_instance)
    klass_instance.should_receive(:call)
  end

  # DEPRECATED
  # Just use e.g. interactor.should_receive(:query).with(...)
  def should_receive_new_with_and_receive_call(klass, *arguments)
    klass_instance = mock()
    klass.should_receive(:new).with(*arguments).and_return(klass_instance)
    klass_instance.should_receive(:call)
  end

  # TODO why is this in pavlov support, this should be put in some general
  # support file or spec_helper.
  def stub_classes *classnames
    classnames.each do |classname|
      stub_const classname, Class.new
    end
  end

  def expect_validating *args
    expect {described_class.new(*args)}
  end

  def fail_validation message
    raise_error(Pavlov::ValidationError, message)
  end

  class ExecuteAsUser
    include Pavlov::Helpers

    attr_reader :current_user
    def initialize user
      @current_user = user
    end

    def pavlov_options
      { current_user: current_user,
        ability: current_ability}
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def execute &block
      yield self
    end
  end

  def as user, &block
    @execute_as_user ||= {}
    @execute_as_user[user] ||= ExecuteAsUser.new(user)
    @execute_as_user[user].execute &block
  end
end
