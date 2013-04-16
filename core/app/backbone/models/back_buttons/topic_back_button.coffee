class window.TopicBackButton extends BackButton

  update: ->
    topic = @model
    @set url: topic.url(), text: topic.get('title')
