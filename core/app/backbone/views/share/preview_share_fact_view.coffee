class window.PreviewShareFactView extends Backbone.Marionette.Layout
  className: 'preview-share-fact'

  template:
    text: """
      <div><strong>Share to social networks:</strong></div>

      <div class="preview-share-fact-link-container">
        <a target="_blank" href="#">&ldquo;{{displaystring}}&rdquo;</a>
      </div>

      <div class="pull-right">
        <span class="js-share-buttons-region"></span>
        <button class="button button-confirm" data-disable-with="Sharing...">Share</button>
      </div>
    """

  regions:
    shareButtonsRegion: '.js-share-buttons-region'

  onRender: ->
    @shareButtonsRegion.show new ShareButtonsView
      model: @options.factSharingOptions
