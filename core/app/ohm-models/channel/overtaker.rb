class Channel < OurOhm
  module Overtaker
    def take_over(ch)
      ch.sorted_internal_facts.each do |f|
        interactor = Interactors::Channels::AddFact.new f, self, no_current_user: true
        interactor.call
      end
      ch.sorted_delete_facts.each do |f|
        self.remove_fact f
      end
      ch.contained_channels.each do |subch|
        self.add_channel subch
      end
    end
  end
end
