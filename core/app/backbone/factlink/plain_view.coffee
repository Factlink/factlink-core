Backbone.Factlink ||= {}
class Backbone.Factlink.PlainView extends Backbone.View

  render: ->
    this.el.innerHTML = this.templateRender(this.model.toJSON())
    if (this.onRender)
      this.onRender();

_.extend(Backbone.Factlink.PlainView.prototype, TemplateMixin);