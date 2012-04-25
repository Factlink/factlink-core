module Facts
  class ExtendedFact < Mustache::Railstache
    include BaseViews::FactBase
    include BaseViews::FactBubbleBase

    def factlink_path
      link_to "Factlink", friendly_fact_path(self[:fact])
    end

    def created_by
      self[:fact].created_by.user.username
    end

    def created_by_url
      user_profile_path(self[:fact].created_by.user)
    end

    def created_by_ago
      "#{time_ago_in_words(self[:fact].data.created_at)} ago"
    end

    def users_authority
      Authority.on(self[:fact], for: current_graph_user).to_s.to_f + 1.0
    end

    def believers_count
      self[:fact].opiniated(:believes).count
    end
    def disbelievers_count
      self[:fact].opiniated(:disbelieves).count
    end
    def doubters_count
      self[:fact].opiniated(:doubts).count
    end

    def believers_text
      t(:fact_believe_opinion).titleize
    end
    def doubters_text
      t(:fact_doubt_opinion).titleize
    end
    def disbelievers_text
      t(:fact_disbelieve_opinion).titleize
    end
  end
end