class window.RelatedUsersView extends Backbone.View
  render: ->
    if @model.get 'topic_url'
      $.ajax
        url: @model.get('topic_url') + '/related_users',
        success: ( data ) => @$el.html(data)
      
    else
      @$el.html []
