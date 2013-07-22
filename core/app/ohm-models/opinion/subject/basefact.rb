class Opinion < OurOhm
  module Subject
    module Basefact

      def self.included(klass)
        klass.reference :user_opinion, Opinion
      end

      def get_user_opinion(depth=0)
        calculate_user_opinion if depth > 0
        user_opinion || Opinion.zero
      end

      def set_user_opinion(new_opinion)
        if user_opinion
          user_opinion.take_values new_opinion
        else
          new_opinion.save
          send :"user_opinion=", new_opinion
        end
      end

      def calculate_user_opinion
        user_opinion = UserOpinionCalculation.new(believable) do |user|
          Authority.on(self, for: user).to_f + 1.0
        end.opinion

        set_user_opinion user_opinion
        save
      end

    end
  end
end
