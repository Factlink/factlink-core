class window.ChannelBackButton extends BackButton

  update: ->
    channel = @model
    @set url: channel.url(), text: channel.get('title')
