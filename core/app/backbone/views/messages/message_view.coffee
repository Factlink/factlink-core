class OneMessageView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template:
    text: """
      <b>{{sender}}</b> {{content}}
    """

class window.MessageView extends Backbone.Marionette.CompositeView
  itemView: OneMessageView
  itemViewContainer: 'ul'

  template:
    text: """
          <h1>Discussie over factlink factlink {{subject.id}}</h1>
          <ul></ul>
    """