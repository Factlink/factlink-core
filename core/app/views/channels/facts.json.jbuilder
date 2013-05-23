json.array!(@facts) do |fact|
  json.partial! 'facts/fact',
              fact: fact[:item],
              channel: @channel,
              timestamp: fact[:score]
end
