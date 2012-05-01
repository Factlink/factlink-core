(function(){
window.ExtendedFactView = FactView.extend({
  tagName: "section",
  id: "main-wrapper",

  initialize: function(opts) {
    this.useTemplate('facts','_extended_fact'); // use after setting this.tmpl

    this.model.bind('destroy', this.remove, this);
    this.model.bind('change', this.render, this);

    this.initAddToChannel();
    this.initFactRelationsViews();
    this.initUserPassportViews();

    this.factWheelView = new InteractiveWheelView({
      model: new Wheel(this.model.get('fact_wheel')),
      el: this.$el.find('.wheel'),
      fact: this.model
    }).render();
  }
});
})();
