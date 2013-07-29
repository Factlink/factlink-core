json.array!(@interactors) do |data|
  json.partial! 'fact_interactors/interactors_partial', data: data
end
