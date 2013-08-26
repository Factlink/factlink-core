class window.DeleteButtonView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'delete-button'

  template:
    text: """
      <span class="delete-button-second-container">
        <span class="delete-button-second button button-small button-danger js-second">Delete</span>
        <span class="delete-button-arrow"></span>
      </span>
      <span class="delete-button-first js-first">D</span>
    """

  events:
    'click .js-first': '_toggleButton'
    'mouseleave': '_closeButton'

  triggers:
    'click .js-second': 'delete'

  _toggleButton: ->
    @$el.toggleClass 'delete-button-open'

  _closeButton: ->
    @$el.removeClass 'delete-button-open'
