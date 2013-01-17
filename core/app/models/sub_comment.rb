class SubComment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :parent_class
  field :parent_id
  field :content,           type: String
  belongs_to :created_by, class_name: 'User'

  index({ parent_id: 1, parent_class: 1, created_at: 1})

  def parent
    if parent_class == 'Comment'
      Comment.find(parent_id)
    else
      FactRelation[parent_id]
    end
  end

  def type
    if parent.type == :weakening || :disbelieves
      return :weakening
    else
      return :supporting
    end
  end
end
