class window.TopicBackButton extends BackButton

  update: ->
    topic = @options.model
    @set url: topic.url(), text: topic.get('title')
