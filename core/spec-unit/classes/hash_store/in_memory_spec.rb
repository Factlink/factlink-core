require_relative '../../../app/classes/hash_store/in_memory.rb'
require_relative './../hash_store_shared.rb'

describe HashStore::InMemory do
  it_behaves_like 'a nested hash store'
end

