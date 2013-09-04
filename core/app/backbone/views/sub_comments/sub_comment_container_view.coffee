class window.SubCommentContainerView extends Backbone.Marionette.Layout
  className: 'sub-comment-container'
  template: 'sub_comments/ndp_sub_comment_container'

  regions:
    headingRegion: '.js-heading-region'
    innerRegion: '.js-inner-region'

  onRender: ->
    @headingRegion.show new EvidenceishHeadingView model: @options.creator
    @innerRegion.show @options.innerView
