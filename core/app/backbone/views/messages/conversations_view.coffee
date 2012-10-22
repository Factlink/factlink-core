class OneConversationView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template:
    text: """
      id: <b>{{id}}</b> fact_data_id: {{fact_data_id}} recipient_ids: {{recipient_ids}}
    """

class window.ConversationsView extends Backbone.Marionette.CollectionView
  itemView: OneConversationView
  tagName: 'ul'
