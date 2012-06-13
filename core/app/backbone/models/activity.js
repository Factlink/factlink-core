(function(){
window.Activity = Backbone.Model.extend({
  getActivity: function() {
    return new Activity(this);
  }
});
}());
