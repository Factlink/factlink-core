window.TextView = Backbone.Marionette.ItemView.extend({
  template: 'generic/text',
  
  onRender: function(){
    console.info('RENDERING TEXT to ', this.$el);
  }
})