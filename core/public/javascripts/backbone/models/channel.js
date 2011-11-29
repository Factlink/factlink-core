window.Channel = Backbone.Model.extend({
  initialize: function(opts) {
    this.bind('activate', this.setActive);
    this.bind('deactivate', this.setNotActive);
    
    this.user = new User(opts.created_by);
  },
  
  setActive: function() {
    this.isActive = true;
  },
  
  setNotActive: function() {
    this.isActive = false;
  }
});