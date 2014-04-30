ReactCommentFacebookShare = React.createBackboneClass
  displayName: 'ReactCommentFacebookShare'

  _description: ->
    left_quote = "\u201C"
    right_quote = "\u201D"

    @model().creator().get('name') + ': ' +
      left_quote + @model().textContent() + right_quote

  _fact: -> @model().collection.fact

  _share: ->
    FB.ui
      method: 'feed'
      link: @_fact().sharingUrl()
      caption: @_fact().factUrlHost()
      description: @_description()

  render: ->
    _a [
      'sliding-facebook-button'
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
      console.info('Tried to use Twitter button while Twitter has not been loaded')

  componentDidMount: -> updateTwitter()
  componentDidUpdate: -> updateTwitter()

  render: ->
    _a [
      'sliding-twitter-button'
      href: @_link()
      target: '_blank' # for if twitter is not yet loaded
      onClick: @_onClick
    ],
      _i ["icon-twitter"]


window.ReactSlidingShareButton = React.createBackboneClass
  displayName: 'ReactSlidingShareButton'

  render: ->
    ReactSlidingButton {label: 'Share ', initialOpened: @model().justCreated(), right: true},
      ReactCommentFacebookShare
        model: @model()
      ' '
      ReactCommentTwitterShare
        model: @model()
