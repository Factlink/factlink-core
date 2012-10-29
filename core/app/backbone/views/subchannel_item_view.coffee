class window.SubchannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"
  events:
    click: "clickHandler"
    "click .close": "destroySubchannel"

  template: "subchannels/_subchannel_item"
  initialize: ->
    @model.bind "destroy", @close, this

  destroySubchannel: (e) ->
    @model.destroy()  if confirm("Are you sure you want to remove this channel from your channel?")
    e.stopPropagation()
    false

  onRender: ->
    @$('i.close').hide() unless currentChannel.user().get('id') == currentUser.get('id')

  clickHandler: (e) ->
    return  if e.metaKey or e.ctrlKey or e.altKey
    mp_track "Channel: Click on subchannel",
      channel_id: currentChannel.id
      subchannel_id: @model.id

    Backbone.history.navigate @model.get("created_by").username + "/channels/" + @model.id, true
    e.preventDefault()
    false
