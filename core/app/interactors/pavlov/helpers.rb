module Pavlov
  module Helpers
    def interactor name, *args
      Pavlov.interactor name, *args, pavlov_options
    end

    def query name, *args
      Pavlov.query name, *args, pavlov_options
    end

    def command name, *args
      Pavlov.command name, *args, pavlov_options
    end

    def pavlov_options
      {}
    end
  end
end