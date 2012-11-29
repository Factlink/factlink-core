module Commands
  module Comments
    class SetOpinion
      include Pavlov::Command

      arguments :comment_id, :opinion_type

      def execute
        puts "I could set an opinion, if I were implemented"
      end
    end
  end
end
