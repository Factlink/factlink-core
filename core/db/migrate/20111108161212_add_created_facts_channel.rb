class GraphUser < OurOhm
  reference :created_facts_channel, Channel::CreatedFacts
  def create_created_facts_channel
    self.created_facts_channel = Channel::CreatedFacts.create(:created_by => self)
    save
  end
end
class AddCreatedFactsChannel < Mongoid::Migration
  def self.up
    GraphUser.all.each do |gu|
      gu.create_created_facts_channel
    end
  end

  def self.down
  end
end