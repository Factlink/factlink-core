window.OwnChannelItemView = Backbone.View.extend({
  tagName: "li",

  events: {
    "change input" : "change"
  },

  initialize: function(opts) {
    this.useTemplate("channels", "_own_channel");

    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
    this.model.bind('remove', this.remove, this);

    this.forFact = opts.forFact;
    this.forChannel = opts.forChannel;
    this.rootView = opts.rootView;
  },

  render: function() {
    this.$el
      .html( this.tmpl.render( this.model.toJSON() ) );

    this.$el.find('input').prop('checked', this.model.checked === true ? true : false);

    return this;
  },

  remove: function() {
    this.$el.remove();
  },

  disable: function() {
    this.$el.find('input').prop('disabled',true);
  },

  enable: function() {
    this.$el.find('input').prop('disabled',false);
  },

  change: function( e ) {
    var self = this;
    var checked = e.target.checked;
    var action = checked ? "add" : "remove";

    self.disable();

    var changeUrl;

    if ( self.forChannel ) {
      changeUrl = this.model.url() + '/subchannels/' + action + '/' + self.forChannel.id + '.json';
    } else if ( self.forFact ) {
      changeUrl = this.model.url() + '/' + action + '/' + self.forFact.id + '.json';
    } else {
      self.enable();

      if ( checked ) {
        self.rootView.selectedChannels.push(self.model.id);
      }

      return;
    }

    $.ajax({
      url: changeUrl,
      type: "post",
      success: function(data) {
        var model = self.forFact || self.forChannel;

        try {
          var mpdata = {
            channel_id: self.model.id,
            added: checked
          };

          if ( self.forChannel ) {
            mpdata.subchannel_id = self.forChannel.id;
          } else {
            mpdata.factlink_id = self.forFact.id;
          }

          mpmetrics.track("Channel: content changed", mpdata);
        } catch(e) {}

        if ( checked ) {
          model.get('containing_channel_ids').push(self.model.id);
        } else {
          var indexOf = model.get('containing_channel_ids').indexOf(self.model.id);
          if ( indexOf ) {
            model.get('containing_channel_ids').splice(indexOf, 1);
          }
        }

        self.enable();
      },
      error: function() {
        e.target.checked = !checked;

        self.enable();
      }
    });
  }
});
