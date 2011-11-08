class Channel < OurOhm
  class CreatedFacts < Channel
    include Channel::GeneratedChannel
    

     def add_fields
       self.title = "All"
       self.description = "All facts"
     end
     before :validate, :add_fields
   
  
     def contained_channels
       created_by.internal_channels
     end
   

  end
end