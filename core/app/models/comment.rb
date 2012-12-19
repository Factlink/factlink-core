class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :authority

  belongs_to :fact_data, class_name: 'FactData'

  field :type,              type: String
  field :content,           type: String
  belongs_to :created_by, class_name: 'User', inverse_of: :comments

  index({ fact_data: 1, opinion: 1, created_at: 1})

  def people_believes
    Believable::Commentje.new(self).people_believes
  end

  def deletable?
    has_no_believers = people_believes.ids == []
    creator_is_only_believer = people_believes.ids.map {|i| i.to_i} == [created_by.graph_user_id.to_i]

    sub_comment_count = Queries::SubComments::Count.new(id.to_s, 'Comment').execute
    has_no_sub_comments = sub_comment_count == 0

    (has_no_believers or creator_is_only_believer) and has_no_sub_comments
  end
end
