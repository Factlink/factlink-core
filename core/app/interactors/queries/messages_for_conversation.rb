class MessagesForConversation
  include Query
  def initialize(conversation)
    @id = conversation.id
    @conversation = conversation
  end
  def execute
    [
      Hashie::Mash.new({
        sender: 'mark',
        content: 'hoi',
      }),
      Hashie::Mash.new({
        sender: 'gerard',
        content: 'doei',
      })
    ]
  end
end