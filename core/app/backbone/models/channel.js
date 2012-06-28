window.Channel = Backbone.Model.extend({

  initialize: function(opts) {
    this.on('activate', this.setActive);
    this.on('deactivate', this.setNotActive);
  },

  setActive: function() {
    this.isActive = true;
  },

  setNotActive: function() {
    this.isActive = false;
  },

  user: function(){
    return new User(this.get('created_by'));
  },

  getOwnContainingChannels: function() {
    var containingChannels = this.get('containing_channel_ids');
    var ret = [];

    currentUser.channels.each(function(ch) {
      if ( _.indexOf(containingChannels, ch.id ) !== -1 ) {
        ret.push(ch);
      }
    });

    return ret;
  },

  url: function() {
    if ( this.collection ) {
      return Backbone.Model.prototype.url.apply(this,arguments);
    } else {
      return '/' + this.get('created_by').username + '/channels/' + this.get('id');
    }
  },

  toJSON: function(){
    var json = Backbone.Model.prototype.toJSON.apply(this);
    return _.extend(json,{
      'chrome_extension_url': '<%= FactlinkUI::Application.config.static_url + "/chrome/factlink-latest.crx" %>',
      'brain_icon': '<%= image_tag image_path("brain.png") %>',
      'channel_definition': '<%= I18n.t(:channel) %>',
      'channels_definition': '<%= I18n.t(:channels) %>',
      'add_to_channels_definition': '<%= I18n.t(:add_to_channels) %>'
    })
  }
});
