//= require jquery.hoverIntent


// dirty way of factoring out copypasted code, but we should not have those mega-controller views
// refactor correctly if this object annoys you ;)
window.CommonChannelStuff = {
  initSubChannels: function() {
    if (this.model.get('inspectable?')){
      this.subchannelView = new SubchannelsView({
        collection: this.model.subchannels(),
        model: this.model
      });
    }
  },

  renderSubChannels: function(){
    if (this.subchannelView) {
      this.subchannelView.render();
      this.$('header .button-wrap').after(this.subchannelView.el);
    }
  },
};


window.ChannelView = Backbone.View.extend({
  tagName: "div",

  template: 'channels/_channel',

  initialize: function(opts) {
    this.factsView = new FactsView({
      collection: new ChannelFacts([],{
        channel: this.model
      }),
      model: this.model
    });
    this.initSubChannels();
  },

  initAddToChannel: function() {
    if ( this.$('#add-to-channel') && typeof currentUser !== "undefined" ) {
      this.addToChannelView = new AddToChannelView({
        collection: currentUser.channels,
        el: this.$('#follow-channel'),
        model: currentChannel,
        containingChannels: currentChannel.getOwnContainingChannels()
      }).render();
    }
  },

  initSubChannelMenu: function() {
    if( this.model.get("followable?") ) {
      var addToChannelButton = this.$el.find("#add-to-channel");
      var followChannelMenu =this.$el.find("#follow-channel");

      followChannelMenu.css({"left": addToChannelButton.position().left});

      addToChannelButton.hoverIntent(
        function() { followChannelMenu.fadeIn("fast"); },
        function() { followChannelMenu.delay(600).fadeOut("fast"); }
      );

      followChannelMenu.on("mouseover", function() {
        followChannelMenu.stop(true, true).show();
      });

      followChannelMenu.on("mouseout", function() {
       if (!followChannelMenu.find("input#channel_title").is(":focus")) {
          followChannelMenu.delay(500).fadeOut("fast");
        }
      });
    }
  },

  remove: function() {
    Backbone.View.prototype.remove.apply(this);

    if ( this.factsView ) {
      this.factsView.close();
    }

    if ( this.addToChannelView ) {
      this.addToChannelView.close();
    }

    if ( this.subchannelView ) {
      this.subchannelView.close();
    }
  },

  render: function() {
    var self = this;

    if ( self.model ) {
      self.model.trigger('loading');

      this.$el
        .html( this.templateRender( this.model.toJSON() ) );

      this.renderSubChannels();
      this.initSubChannelMenu();
      this.initAddToChannel();

      this.factsView.render();
      this.$el.find('#facts_for_channel').append(this.factsView.el);

      // Set the active tab
      var tabs = this.$el.find('.tabs ul');
      tabs.find('li').removeClass('active');
      tabs.find('.factlinks').addClass('active');

      self.model.trigger('loaded')
                  .trigger('activate', self.model);
    }
    this.$el.find('header .authority')
      .tooltip({title: 'Authority of ' + self.model.attributes.created_by.username + ' on "' + self.model.attributes.title + '"'});


    return this;
  }
});

_.extend(ChannelView.prototype, TemplateMixin, CommonChannelStuff);