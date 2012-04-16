window.AddToChannelView = Backbone.View.extend({
  tagName: "div",

  _views: [],

  events: {
    'keyup .channel-title': 'submitFormIfNeeded',
    'click .submit': 'addChannel'
  },

  initialize: function(opts) {
    this.useTemplate("channels", "_own_channel_listing");

    this.collection.bind('add',   this.render, this);
    this.collection.bind('reset', this.render, this);

    if ( this.model ) {
      this.containingChannels = this.model.getOwnContainingChannels();
    }

    if ( opts.forChannel ) {
      this.forChannel = opts.forChannel;
    } else if ( opts.forFact ) {
      this.forFact = opts.forFact;
    } else if ( typeof currentChannel !== "undefined" ){
      this.forChannel = currentChannel;
    } else {
      this.forChannel = false;
    }
  },

  addChannel: function(e) {
    e && e.preventDefault();

    var self = this;

    self.disableAdd();

    var val = self.$input.val();

    if ( val.length > 0 ) {
      var dataHolder = {
        title: val
      };

      if ( self.forChannel ) {
        dataHolder.for_channel= self.forChannel.id;
      } else if ( self.forFact ) {
        dataHolder.for_fact = self.forFact.id;
      }

      $.ajax({
        url: '/' + currentUser.get('username') + '/channels',
        data: dataHolder,
        type: "post",
        success: function(data) {
          try {
            mpmetrics.track("Channel: created", {
              title: dataHolder.title,
              channel_id: data.id
            });

            mpmetrics.track("Channel: content changed", {
              channel_id: data.id,
              subchannel_id: dataHolder.for_channel,
              factlink_id: dataHolder.for_fact,
              added: true
            });
          } catch(e) {}

          if ( self.model ) {
            self.model.get('containing_channel_ids').push(data.id);
          }

          var channel = new Channel(data);

          channel.checked = true;

          currentUser.channels.add(channel);

          self.resetAdd();
          self.enableAdd();
        }
      });
    } else {
      self.enableAdd();
    }

    return false;
  },

  submitFormIfNeeded: function (e) {
    if ( e.keyCode === 13 ) {
      this.addChannel();
    }
  },

  resetAdd: function() {
    this.$input.val('');
  },

  disableAdd: function() {
    this.$input.prop('disabled',true);
    this.$submit.prop('disabled',true);
  },

  enableAdd: function() {
    this.$input.prop('disabled',false);
    this.$submit.prop('disabled',false);
  },

  resetCheckedState: function() {
    var containingChannels = [];

    if ( this.model ) {
      containingChannels = _.map(this.model.getOwnContainingChannels(), function(ch) {
        return ch.id;
      });
    }

    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        if (_.indexOf(containingChannels,channel.id) !== -1 ) {
          channel.checked = true;
        }
      }
    });
  },

  render: function() {
    var self = this;
    var add_model = {};

    if ( this.forChannel ) {
      if (this.collection.get(this.forChannel.id) === undefined) {
        add_model = {'default_add_new_value': this.forChannel.get('title')};
      }
    }


    this.$el
      .html( Mustache.to_html(this.tmpl,add_model) );

    var $channelListing = this.$el.find('ul');

    this.resetCheckedState();

    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        var view = new OwnChannelItemView(
          {
            model: channel,
            forChannel: self.forChannel,
            forFact: self.forFact
          }).render();

        $channelListing.append(view.el);
      }
    });

    this.$input = this.$el.find('input[name="channel_title"]');
    this.$submit = this.$el.find('input[type="submit"]');

    return this;
  }
});
