window.Channel = Backbone.Model.extend({
  initialize: function() {
    this.bind('activate', this.setActive);
    this.bind('deactivate', this.setNotActive);
  },
  
  setActive: function() {
    this.isActive = true;
  },
  
  setNotActive: function() {
    this.isActive = false;
  }
});