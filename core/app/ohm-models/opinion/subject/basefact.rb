class Opinion < OurOhm
  module Subject
    module Basefact
      def Basefact.included(klass)
        klass.opinion_reference :user_opinion do |depth|
          #depth has no meaning here unless we want the depth to also recalculate authorities
          opinions = []
          [:believes, :doubts, :disbelieves].each do |type|
            opiniated = opiniated(type)
            opiniated.each do |user|
              opinions << Opinion.for_type(type, Authority.on(self, for: user).to_f + 1.0)
            end
          end
          Opinion.combine(opinions)
        end
      end
    end
  end
end
