module PavlovSupport
  # TODO why is this in pavlov support, this should be put in some general
  # support file or spec_helper.
  def stub_classes *classnames
    classnames.each do |classname|
      stub_const classname, Class.new
    end
  end

  def expect_validating hash
    hash[:pavlov_options] ||= {}
    hash[:pavlov_options][:ability] ||= double(can?: true)
    expect { described_class.new(hash).call }
  end

  def fail_validation message
    raise_error(Pavlov::ValidationError, message)
  end

  class ExecuteAsUser < Struct.new(:user)
    include Pavlov::Helpers

    def pavlov_options
      Util::PavlovContextSerialization.pavlov_context_by_user user
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
