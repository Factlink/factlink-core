json.partial! partial: 'facts/fact',
          formats: [:json], handlers: [:jbuilder],
          locals: { fact: @fact }
