require_relative '../../../spec-unit/classes/hash_store/shared.rb'
require 'spec_helper'

describe HashStore::Redis do
  include RedisSupport
  it_behaves_like 'a hash store'

  it "does one request per set" do
    nr_commands = number_of_commands_on Redis.current do
      subject['someplace','foo','bar'].set({ a: 'hash'})
    end
    expect(nr_commands).to eq 1
  end

  it "does one request per get" do
    subject['someplace','foo','bar'].set({ a: 'hash'})

    nr_commands = number_of_commands_on Redis.current do
      subject['someplace','foo','bar'].get
    end
    expect(nr_commands).to eq 1
  end

  it "does one request for multiple gets/value? s" do
    subject['someplace','foo','bar'].set({ a: 'hash'})

    nr_commands = number_of_commands_on Redis.current do
      entry = subject['someplace','foo','bar']
      entry.value?
      entry.get
      entry.value?
      entry.get
    end
    expect(nr_commands).to eq 1
  end

  it "does no requests when just indexing" do
    nr_commands = number_of_commands_on Redis.current do
      entry = subject['someplace','foo','bar']
    end
    expect(nr_commands).to eq 0
  end

end
