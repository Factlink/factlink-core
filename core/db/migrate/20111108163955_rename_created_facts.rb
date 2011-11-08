class GraphUser < OurOhm
  reference :created_facts_channel, Channel::CreatedFacts
end

class RenameCreatedFacts < Mongoid::Migration
  def self.up
    GraphUser.all.each do |gu|
      gu.created_facts_channel.add_fields
      gu.created_facts_channel.save
    end
  end

  def self.down
  end
end