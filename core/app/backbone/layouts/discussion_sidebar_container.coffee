window.discussion_sidebar_slide_transition_duration = 400 # keep in sync with CSS

ReactDiscussionSideBarContainerChild = React.createClass
  componentDidEnter: ->
    _.defer =>
      $(@getDOMNode()).addClass 'discussion-sidebar-container-visible'

  componentWillLeave: (done) ->
    $(@getDOMNode()).removeClass 'discussion-sidebar-container-visible'
    _.delay done, discussion_sidebar_slide_transition_duration

  _closeOnContainerClicked: (event) ->
    @_closeModal() if $(event.target).hasClass('discussion-sidebar-container')

  _closeModal: ->
    FactlinkApp.vent.trigger 'close_discussion_sidebar'

  render: ->
    _div [
      "discussion-sidebar-container",
      onClick: @_closeOnContainerClicked
    ],
    _div ["discussion-sidebar"],
      _div ["discussion-sidebar-shadow"]
      _a [
         "discussion-sidebar-close-left"
         href: "javascript:"
         onClick: @_closeModal
       ],
        _i ["icon-right-open"]
      _a [
         "discussion-sidebar-close-top"
         href: "javascript:"
         onClick: @_closeModal
       ],
         _i ["icon-remove"]
      _div [],
        this.props.children


window.ReactDiscussionSideBarContainer = React.createClass
  _wrapChild: (child) ->
    ReactDiscussionSideBarContainerChild {}, child

  render: ->
    React.addons.TransitionGroup {
      component: React.DOM.div
      childFactory: @_wrapChild
    },
      @props.children || []
