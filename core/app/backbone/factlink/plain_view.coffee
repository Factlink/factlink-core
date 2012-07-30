Backbone.Factlink ||= {}
class Backbone.Factlink.PlainView extends Backbone.View

  render: ->
    @$el.html(this.templateRender(this.model?.toJSON()))

    if (@onRender)
      @onRender();
      @trigger('render');

    return this

_.extend(Backbone.Factlink.PlainView.prototype, TemplateMixin)