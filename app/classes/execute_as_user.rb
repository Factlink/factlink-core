class ExecuteAsUser < Struct.new(:user)
  include Pavlov::Helpers

  attr_accessor :send_mails
  attr_accessor :time
  attr_accessor :import

  def pavlov_options
    {
      current_user: user,
      ability: Ability.new(user),
      time: time || Time.now,
      send_mails: send_mails || false,
      import: import || false,
    }
  end

  def execute &block
    yield self
  end
end
