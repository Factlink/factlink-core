ViewWithPopover = extendWithPopover(Backbone.Marionette.ItemView)

class SubCommentPopoverView extends ViewWithPopover
  template: 'sub_comments/popover'

  initialize: (options)->
    @delete_message = options.delete_message

  templateHelpers: =>
    delete_message: @delete_message

  events:
    'click li.delete': 'destroy'

  popover: [
    selector: '.sub-comments-popover-arrow'
    popoverSelector: '.sub-comments-popover'
  ]

  destroy: -> @model.destroy wait: true

class SubCommentView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comment'

  template: 'sub_comments/sub_comment'

  regions:
    popoverRegion: '.js-region-evidence-sub-comment-popover'

  templateHelpers: => creator: @model.creator().toJSON()

  initialize: -> @bindTo @model, 'change', @render, @

  onRender: -> @setPopover()

  setPopover: ->
    if @model.can_destroy()
      popoverView = new SubCommentPopoverView
                          model: @model,
                          delete_message: 'Remove this comment'
      @popoverRegion.show popoverView

class SubCommentsListView extends Backbone.Marionette.CollectionView
  className: 'evidence-sub-comments-list'
  itemView: SubCommentView

class SubCommentsAddView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comments-form'

  template: 'sub_comments/add_view'

  events:
    'click .js-submit': 'submit'

  regions:
    textareaRegion: '.js-region-textarea'

  templateHelpers: => current_user: currentUser.toJSON()

  onRender: ->
    @textareaRegion.show @textAreaView()
    @toggleForm false

  inputFocus: -> @toggleForm true
  inputBlur: -> @toggleForm false if @text().length <= 0

  toggleForm: (active) ->
    @$el.toggleClass 'evidence-sub-comments-form-active', active

  submit: ->
    if @text().length > 0
      @addModel new SubComment
        content: @text()
        created_by: currentUser

  addModelError: -> @alertError()
  addModelSuccess: (model) ->
    @textModel().set 'text', ''
    @alertHide()

  text: -> @textModel().get('text')
  textModel: -> @_textModel ?= new Backbone.Model text: ''
  textAreaView: ->
    textAreaView = new Backbone.Factlink.TextAreaView
      model: @textModel()
      placeholder: 'Comment..'

    @bindTo textAreaView, 'return', @submit, @
    @bindTo textAreaView, 'focus', @inputFocus, @
    @bindTo textAreaView, 'blur', @inputBlur, @
    textAreaView

_.extend SubCommentsAddView.prototype,
  Backbone.Factlink.AddModelToCollectionMixin, Backbone.Factlink.AlertMixin

class window.SubCommentsView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comments'

  template: 'sub_comments/sub_comments'

  regions:
    subCommentsListRegion: '.js-region-sub-comments-list'
    subCommentsFormRegion: '.js-region-sub-comments-form'

  events:
    'click .js-sub-comments-link': 'toggleList'

  onRender: ->
    @bindTo @model, 'change:sub_comments_count', @updateLink, @
    @updateLink()

  toggleList: -> if @listOpen then @closeList() else @openList()

  openList: ->
    @listOpen = true
    @$('.js-sub-comments-list-container').removeClass('hide')

    subComments = new SubComments([], parentModel: @model)
    subComments.fetch update: true # only fires 'add' and 'remove' events

    @bindTo subComments, 'add', => @model.set 'can_destroy?', false
    @bindTo subComments, 'remove', => @model.fetch if subComments.length <= 0
    @bindTo subComments, 'add remove reset', => @model.set 'sub_comments_count', subComments.length

    @subCommentsFormRegion.show new SubCommentsAddView addToCollection: subComments
    @subCommentsListRegion.show new SubCommentsListView collection: subComments

  closeList: ->
    @listOpen = false
    @$('.js-sub-comments-list-container').addClass('hide')
    @subCommentsFormRegion.close()
    @subCommentsListRegion.close()

  updateLink: ->
    count = @model.get('sub_comments_count')

    count_str = ""

    if count
      count_str = " (#{count})"

    @$(".js-sub-comments-link").text "Comments#{count_str}"
