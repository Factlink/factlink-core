class Opinion < OurOhm
  module Subject
    module Basefact

      def get_user_opinion(depth=0)
        calculate_user_opinion if depth > 0
        user_opinion || Opinion.zero
      end

      def calculate_user_opinion
        user_opinion = UserOpinionCalculation.new(believable) do |user|
          Authority.on(self, for: user).to_f + 1.0
        end.opinion

        set_opinion :user_opinion, user_opinion
      end

      protected

      def set_opinion(type, new_opinion)
        original_opinion = send(type)
        if original_opinion
          original_opinion.take_values new_opinion
        else
          send "#{type}=", new_opinion.save
          save
        end
      end

    end
  end
end
