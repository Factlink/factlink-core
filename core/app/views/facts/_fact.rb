module Facts
  class FactView < Mustache::Railstache
    def self.for_fact_and_view(fact, view, channel=nil, modal=nil,timestamp=0)
      fv = new(false)
      fv.view = view
      fv[:channel] = channel
      fv[:fact] = fact
      fv[:modal] = modal
      fv[:timestamp] = timestamp
      fv.init
      return fv
    end

    def initialize(run=true)
      init if run
    end

    def init
    end
  
    def no_evidence_message
      if user_signed_in?
        "Perhaps you know something that supports or weakens this fact?"
      else
        "There are no Factlinks supporting or weakening this Factlink at the moment."
      end
    end
  
    def delete_from_channel_link
      remove_from_channel_path
    end
  
    def deletable_from_channel?
      user_signed_in? and self[:channel] and self[:channel].editable? and self[:channel].created_by == current_graph_user
    end
  
    def remove_from_channel_path
      if self[:channel]
        remove_fact_from_channel_path(current_user.username, self[:channel].id, self[:fact].id)
      end
    end
  
    def fact_relations_count
      self[:fact].fact_relations.count
    end
  
    def signed_in?
      user_signed_in?
    end
  
    def ajax_loader_image
      image_tag("ajax-loader.gif")
    end
  
    def evidence_search_path
      evidence_search_fact_path(self[:fact].id)
    end
  
    def prefilled_search_value
      params[:s] ? "value='#{params[:s]}'" : ""
    end
  
    def evidence_index_path
      fact_evidence_index_path(self[:fact].id)
    end
  
    def id
      self[:fact].id
    end
  
    def displaystring
      self[:fact].data.displaystring
    end
  
    def modal?
      if self[:modal] != nil
        self[:modal]
      else
        false
      end
    end
    
    def fact_bubble
      Facts::FactBubble.for_fact_and_view(self[:fact], self.view)
    end
    
    def containing_channel_ids
      return [] unless current_graph_user
      current_graph_user.containing_channel_ids(self[:fact])
    end
    
    def timestamp
      self[:timestamp]
    end
    
    def to_hash
      {
                             :modal? => modal?,
                         :signed_in? => signed_in?,
                        :fact_bubble => fact_bubble,
                      :displaystring => displaystring,
                  :ajax_loader_image => ajax_loader_image,
                :evidence_index_path => evidence_index_path,
                :no_evidence_message => no_evidence_message,
               :fact_relations_count => fact_relations_count,
               :evidence_search_path => evidence_search_path,
             :containing_channel_ids => containing_channel_ids,
             :prefilled_search_value => prefilled_search_value,
            :deletable_from_channel? => deletable_from_channel?,
           :delete_from_channel_link => delete_from_channel_link,
           :remove_from_channel_path => remove_from_channel_path,
                                 :id => id,
                          :timestamp => timestamp
      }
    end
  end
end