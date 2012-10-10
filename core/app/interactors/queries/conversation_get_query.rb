class ConversationGetQuery
  include Query
  def initialize(id)
    @id = id
  end
  def execute
    Hashie::Mash.new({
      id: 14,
      subject_type: :fact,
      subject_id: 414
    })
  end
end