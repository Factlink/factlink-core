module PavlovSupport
  # TODO why is this in pavlov support, this should be put in some general
  # support file or spec_helper.
  def stub_classes *classnames
    classnames.each do |classname|
      stub_const classname, Class.new
    end
  end

  def expect_validating *args
    options = {ability: mock(can?: true)}
    expect {described_class.new(*args, options)}
  end

  def fail_validation message
    raise_error(Pavlov::ValidationError, message)
  end

  class ExecuteAsUser < Struct.new(:user)
    include Pavlov::Helpers

    def pavlov_options
      {
        current_user: user,
        ability: ability,
        facebook_app_namespace: FactlinkUI::Application.config.facebook_app_namespace
      }
    end

    def ability
      @ability ||= Ability.new(user)
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
