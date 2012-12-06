//= require jquery.hoverIntent

window.ChannelViewLayout = Backbone.Marionette.Layout.extend({
  tagName: "div",

  template: 'channels/channel',

  regions: {
    factList: '#facts_for_channel',
    activityList: '#activity_for_channel',
    addToChannelRegion: '.add-to-channel-region'
  },

  templateHelpers: function(){
    return {
      activities_link: function(){ return this.link + "/activities";}
    };
  },
  initialize: function(opts) {
    this.initSubChannels();
    this.on('render', _.bind(function(){
      this.renderSubChannels();
      this.$('header .authority').tooltip({title: 'Authority of ' + this.model.attributes.created_by.username + ' on "' + this.model.attributes.title + '"'});
      if( this.model.get("followable?") ) {
        this.addToChannelRegion.show(new AddChannelToChannelsModalView({
          model: this.model
        }));
      }
    },this));
  },

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

  onClose: function() {
    if ( this.addToChannelView ) {
      this.addToChannelView.close();
    }

    if ( this.subchannelView ) {
      this.subchannelView.close();
    }
  },
  activateTab: function(selector) {
    var tabs = this.$('.tabs ul');
    tabs.find('li').removeClass('active');
    tabs.find(selector).addClass('active');
  }
});

window.ChannelView = ChannelViewLayout.extend({

  getFactsView: function() {
    return new FactsView({
      collection: new ChannelFacts([],{
        channel: this.model
      }),
      model: this.model
    });
  },

  onRender: function() {
    this.factList.show(this.getFactsView());
    this.activateTab(".factlinks");
  }
});


window.ChannelActivitiesView = ChannelViewLayout.extend({

  getActivitiesView: function(){
    return new ActivitiesView({collection: this.collection});
  },

  onRender: function() {
    this.activityList.show(this.getActivitiesView());
    this.activateTab('.activity');
  }

});
