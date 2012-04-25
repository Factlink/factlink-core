(function(){
window.ExtendedFactView = FactView.extend({
  tagName: "section",
  id: "main-wrapper",

  initialize: function(opts) {
    this.useTemplate('facts','_extended_fact'); // use after setting this.tmpl

    this.model.bind('destroy', this.remove, this);
    this.model.bind('change', this.render, this);

    this.$el.attr('data-fact-id', ( this.model.id || this.model.cid )).factlink();

    this.initAddToChannel();
    this.initFactRelationsViews();
    this.initUserPassportViews();
  }
});
})();
