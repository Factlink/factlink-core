class window.ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/item'
  events:
    'click' : 'wholeElementClick'
    'click .user-profile-link' : 'userProfileLinkClick'

  templateHelpers: =>
    url: @model.url()

  wholeElementClick: (e) ->
    url = @model.url()
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate url, true

  userProfileLinkClick: (e) ->
    console.info ('click"')
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate @model.get('last_message').sender.username, true
