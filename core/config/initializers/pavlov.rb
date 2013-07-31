# Monkey patch to introduce pavlov_options before upgrading

module Pavlov
  module Operation
    def pavlov_options
      @options
    end
    def pavlov_options=(options)
      @options = options
    end
  end

  def self.old_command *arguments
    command *arguments
  end
  def self.old_query *arguments
    query *arguments
  end
  def self.old_interactor *arguments
    interactor *arguments
  end

  module Helpers
    def old_interactor name, *args
      args = add_pavlov_options args
      Pavlov.old_interactor name, *args
    end

    def old_query name, *args
      args = add_pavlov_options args
      Pavlov.old_query name, *args
    end

    def old_command name, *args
      args = add_pavlov_options args
      Pavlov.old_command name, *args
    end
  end
end
