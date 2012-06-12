(function(){
window.Activity = Backbone.Model.extend({
  getUser: function() {
    return new User({
      avatar:           this.get('avatar'),
      username:         this.get('username'),
      user_profile_url: this.get('user_profile_url')
    });
  }
});
}());
