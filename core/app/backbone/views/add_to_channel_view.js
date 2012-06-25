window.AddToChannelView = Backbone.View.extend({
  tagName: "div",

  _views: [],

  events: {
    'keyup .channel-title': 'submitFormIfNeeded',
    'click .submit': 'addChannel'
  },

  template: "channels/_own_channel_listing",

  initialize: function(opts) {
    this.collection.bind('add',   this.render, this);
    this.collection.bind('reset', this.render, this);

    if ( this.model ) {
      this.containingChannels = this.model.getOwnContainingChannels();
    } else {
      this.selectedChannels = [];
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
          mp_track("Channel: created", {
            title: dataHolder.title,
            channel_id: data.id
          });

          mp_track("Channel: content changed", {
            channel_id: data.id,
            subchannel_id: dataHolder.for_channel,
            factlink_id: dataHolder.for_fact,
            added: true
          });

          if ( self.model ) {
            self.model.get('containing_channel_ids').push(data.id);
          } else {
            self.selectedChannels.push(data.id);
          }

          currentUser.channels.add(data);

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
    var self = this;
    var containingChannels = [];

    if ( this.model ) {
      containingChannels = _.map(this.model.getOwnContainingChannels(), function(ch) {
        return ch.id;
      });
    }

    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        channel.checked = false;

        if (_.indexOf(containingChannels,channel.id) !== -1 || _.indexOf(self.selectedChannels, channel.id) !== -1 ) {
          channel.checked = true;
        }
      }
    });
  },

  render: function() {
    var self = this;
    var add_model = {};

    if ( this.forChannel ) {
      if (this.collection.get(this.forChannel.id) === undefined && this.collection.where({'title': this.forChannel.get('title')}).length == 0) {
        add_model = {'default_add_new_value': this.forChannel.get('title')};
      }
    }


    this.$el
      .html( this.templateRender(add_model) );

    var $channelListing = this.$el.find('ul');

    $channelListing.preventScrollPropagation();

    this.resetCheckedState();

    this.collection.each(function(channel) {
      if ( channel.get('editable?') ) {
        var view = new OwnChannelItemView(
          {
            model: channel,
            forChannel: self.forChannel,
            forFact: self.forFact,
            rootView: self
          }).render();

        $channelListing.append(view.el);
      }
    });

    this.$input = this.$el.find('input[name="channel_title"]');
    this.$submit = this.$el.find('input[type="submit"]');

    return this;
  },

  resetClickedState: function () {
    this.selectedChannels = [];
    this.render();
  }
});

_.extend(AddToChannelView.prototype, TemplateMixin);