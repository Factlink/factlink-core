class window.UserPassportView extends Backbone.View
  tagName: "li"
  className: "user"
  events:
    mouseenter: "show"
    mouseleave: "hide"

  template: "users/_user_passport"

  initialize: (opts) ->
    @shouldShow = false
    @model.bind "change", @render, this

  render: ->
    @$(".passport").html @templateRender(@model.toJSON())
    @$(".activity", @$(".passport")).html(@options.activity["internationalized_action"]).addClass @options.activity["action"]

  show: ->
    @shouldShow = true
    @$(".passport").fadeIn "fast"

  hide: ->
    @shouldShow = false
    _.delay _.bind(=>@$(".passport").fadeOut "fast" unless @shouldShow), 150

_.extend UserPassportView::, TemplateMixin
