require_relative '../../../spec-unit/classes/hash_store/shared.rb'
require 'spec_helper'

describe HashStore::Redis do
  include RedisSupport
  it_behaves_like 'a hash store'

  describe "number of requests" do

    it "is one per set" do
      nr_commands = number_of_commands_on Redis.current do
        subject['someplace','foo','bar'].set({ a: 'hash'})
      end
      expect(nr_commands).to eq 1
    end

    it "is one per get" do
      subject['someplace','foo','bar'].set({ a: 'hash'})

      nr_commands = number_of_commands_on Redis.current do
        subject['someplace','foo','bar'].get
      end
      expect(nr_commands).to eq 1
    end

    it "is one for multiple gets/value? s" do
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

    it "is none when just indexing" do
      nr_commands = number_of_commands_on Redis.current do
        entry = subject['someplace','foo','bar']
      end
      expect(nr_commands).to eq 0
    end
  end

  describe "stale data" do
    it "happens when keeping reference to an entry" do
      subject['someplace','foo','bar'].set({some: 'hash'})

      entry = subject['someplace','foo','bar']
      entry.get # force initial fetch

      subject['someplace','foo','bar'].set({some: 'other_hash'})

      expect(entry.get).to eq({some: 'hash'})
    end
    it "doesn't happen when refetching an entry" do
      subject['someplace','foo','bar'].set({some: 'hash'})

      entry = subject['someplace','foo','bar']
      entry.get # force initial fetch

      subject['someplace','foo','bar'].set({some: 'other_hash'})

      refetched_entry = subject['someplace','foo','bar']

      expect(refetched_entry.get).to eq({some: 'other_hash'})

    end
  end
end
