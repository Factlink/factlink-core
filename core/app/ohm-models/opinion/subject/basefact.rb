class Opinion < OurOhm
  module Subject
    module Basefact

      OurOhm.value_reference :user_opinion, Opinion

      def calculate_user_opinion
        user_opinion = UserOpinionCalculation.new(believable) do |user|
          Authority.on(self, for: user).to_f + 1.0
        end.opinion

        update_attribute :user_opinion, user_opinion
      end

      def get_user_opinion(depth=0)
        calculate_user_opinion if depth > 0
        user_opinion || Opinion.zero
      end

    end
  end
end
