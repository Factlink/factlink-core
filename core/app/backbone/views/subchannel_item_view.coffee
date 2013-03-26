class window.SubchannelItemView extends Backbone.Marionette.ItemView
  tagName: "li"
  events:
    click: "clickHandler"
    "click .close": "destroySubchannel"

  template: "subchannels/subchannel_item"
  templateHelpers: ->
    created_by: @model.user().toJSON()

  initialize: ->
    @model.bind "destroy", @close, this

  destroySubchannel: (e) ->
    @model.destroy()  if confirm("Are you sure you want to unfollow this channel from your #{Factlink.Global.t.topic}?")
    e.stopPropagation()
    false

  onRender: ->
    @$('i.close').hide() unless currentChannel.user().get('id') == currentUser.get('id')

  clickHandler: (e) ->
    mp_track "Topic: Click on subchannel",
      channel_id: currentChannel.id
      subchannel_id: @model.id

    @defaultClickHandler e
