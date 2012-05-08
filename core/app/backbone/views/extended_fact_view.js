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

    this.wheel = new Wheel(this.model.get('fact_wheel'));

    this.factWheelView = new InteractiveWheelView({
      model: this.wheel,
      fact: this.model,
      el: this.$el.find('.wheel')
    }).render();
  }
});
})();
