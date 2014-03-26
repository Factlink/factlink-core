componentKey = 0
getComponentKey = -> componentKey++

window.discussion_sidebar_slide_transition_duration = 400 # keep in sync with CSS

window.ReactDiscussionSideBarContainer = React.createClass
  _closeOnContainerClicked: (event)->
    console.info event.target
    @_closeModal() if $(event.target).hasClass('discussion-sidebar-container')

  _closeModal: ->
    FactlinkApp.vent.trigger 'close_discussion_sidebar'

  render: ->
    React.addons.CSSTransitionGroup {
      transitionName:"discussion-sidebar-container"
    },
      if !this.props.children
        []
      else
        [
          _div [
              "discussion-sidebar-container",
              "spec-discussion-sidebar-container",
              onClick: @_closeOnContainerClicked
              key: getComponentKey()
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
              _div ["js-modal-content"],
                this.props.children
        ]
