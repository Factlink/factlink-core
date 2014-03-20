ReactCommentFacebookShare = React.createBackboneClass
  displayName: 'ReactCommentFacebookShare'

  _description: ->
    left_quote = "\u201C"
    right_quote = "\u201D"

    left_quote + @model().textContent() + right_quote

  _share: ->
    FB.ui
      method: 'feed'
      link: @model().collection.fact.sharingUrl()
      description: @_description()

  render: ->
    _a [
      'button-facebook'
      'button-small'
      'button-arrow-left'
      'sliding-share-button'
      onClick: @_share
    ],
      _i ["icon-facebook"]


updateTwitter = ->
  return if Factlink.Global.environment == 'test' # Twitter not loaded in tests

  twttr.widgets?.load()


ReactCommentTwitterShare = React.createBackboneClass
  displayName: 'ReactCommentTwitterShare'

  _link: ->
    url = encodeURIComponent @model().collection.fact.sharingUrl()
    text = encodeURIComponent @model().textContent()

    "https://twitter.com/intent/tweet?url=#{url}&text=#{text}&related=factlink"

  _onClick: ->
    unless twttr.widgets?
      ravenCapture('Tried to use Twitter button while Twitter has not been loaded')

  componentDidMount: -> updateTwitter()
  componentDidUpdate: -> updateTwitter()

  render: ->
    _a [
      'button-twitter'
      'button-small'
      'sliding-share-button'
      href: @_link()
      target: '_blank' # for if twitter is not yet loaded
      onClick: @_onClick
    ],
      _i ["icon-twitter"]


window.ReactSlidingShareButton = React.createBackboneClass
  displayName: 'ReactSlidingShareButton'

  render: ->
    nbsp = "\u00a0"

    ReactSlidingButton {label: 'Share', initialOpened: @model().justCreated(), right: true},
      _span [],
        nbsp
        ReactCommentFacebookShare
          model: @model()
        nbsp
        ReactCommentTwitterShare
          model: @model()
