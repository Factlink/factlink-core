class Channel < OurOhm
  class CreatedFacts < Channel
    include Channel::GeneratedChannel
    

     def add_fields
       self.title = "Created"
       self.description = "Created Facts"
     end
     before :validate, :add_fields
   
  
     def contained_channels
       []
     end
   

  end
end