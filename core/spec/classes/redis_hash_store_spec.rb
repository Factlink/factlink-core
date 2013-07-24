require_relative '../../spec-unit/classes/hash_store_shared.rb'
require 'spec_helper'

describe RedisHashStore do
  include RedisSupport
  it_behaves_like 'a nested hash store'

  it "does one request per set" do
    nr_commands = number_of_commands_on Redis.current do
      subject['someplace','foo','bar'] = { a: 'hash'}
    end
    expect(nr_commands).to eq 1
  end

  it "does one request per get" do
    subject['someplace','foo','bar'] = { a: 'hash'}

    nr_commands = number_of_commands_on Redis.current do
      subject['someplace','foo','bar'].get
    end
    expect(nr_commands).to eq 1
  end

  it "does one request for multiple gets/value? s" do
    subject['someplace','foo','bar'] = { a: 'hash'}

    nr_commands = number_of_commands_on Redis.current do
      retrieved = subject['someplace','foo','bar']
      retrieved.value?
      retrieved.get
      retrieved.value?
      retrieved.get
    end
    expect(nr_commands).to eq 1

  end

end
