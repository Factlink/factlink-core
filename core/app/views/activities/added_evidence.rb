module Activities
  class AddedEvidence < Mustache::Railstache

    # override
    def action
      "added"
    end

    def evidence
      self[:activity].subject.to_s
    end

    def evidence_url
      friendly_fact_path(self[:activity].subject)
    end

    def fact
      self[:activity].object.to_s
    end

    def fact_url
      friendly_fact_path(self[:activity].object)
    end


    def type
      the_action = self[:activity].action
      if the_action == "added_supporting_evidence"
        "supporting"
      else
        "weakening"
      end
    end

    def icon
      image_tag('activities/icon-evidencetofactlink.png')
    end


  end
end