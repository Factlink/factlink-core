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
    def old_interactor *args
     interactor *args
    end
    def old_command *args
     command *args
    end
    def old_query *args
     query *args
    end
  end
end
