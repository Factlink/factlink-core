class window.ShareFactView extends Backbone.Marionette.Layout
  className: 'share-fact'

  template: 'share/share_fact'

  events:
    'click .js-share': '_share'

  regions:
    textareaRegion: '.js-textarea-region'
    shareCommentRegion: '.js-share-comment-region'

  onRender: ->
    @_textModel = new Backbone.Model text: ''
    @_textAreaView = new Backbone.Factlink.TextAreaView
      model: @_textModel
      placeholder: 'Message (optional)'
    @textareaRegion.show @_textAreaView

    @_shareCommentView = new ShareCommentView model: @model
    @shareCommentRegion.show @_shareCommentView

  _share: ->
    @_shareCommentView.submit @_textModel.get('text')
