class window.ChannelBackButton extends BackButton

  update: ->
    channel = @options.model
    url = channel.url()
    url = url + "/activities" if @options.for_stream
    @set url: url, text: channel.get('title')
