class Channel < OurOhm
  class UserStream < Channel
    include Channel::GeneratedChannel

    def add_fields
       self.title = "All"
     end
     before :validate, :add_fields
   
     def contained_channels
       channels = created_by.internal_channels.to_a
       channels.delete(self)
       return channels
     end
   
     def inspect
       "UserStream of #{created_by}"
     end
   
  end
end