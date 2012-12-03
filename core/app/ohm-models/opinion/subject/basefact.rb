class Opinion < OurOhm
  module Subject
    module Basefact
      def Basefact.included(klass)
        klass.opinion_reference :user_opinion do |depth|
          #depth has no meaning here unless we want the depth to also recalculate authorities
          UserOpinionCalculation.new(believable) do |user|
            Authority.on(self, for: user).to_f + 1.0
          end.opinion
        end
      end
    end
  end
end
