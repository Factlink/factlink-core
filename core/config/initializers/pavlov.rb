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

  def old_command *arguments
    command *arguments
  end
  def old_query *arguments
    query *arguments
  end
  def old_interactor *arguments
    interactor *arguments
  end
end
