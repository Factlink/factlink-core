window.SubchannelsView = Backbone.Factlink.CompositeView.extend({
  tagName: "div",
  id: "contained-channels",
  template: 'channels/subchannels',
  itemView: SubchannelItemView,

  events: {
    'click #more-button': 'toggleMore'
  },

  initialize: function() {
    this.collection.bind('remove', this.render, this);
  },

  toggleMore: function() {
    var button = this.$("#more-button .label");
    this.$('.overflow').slideToggle(function(e) {
      button.text($(button).text() === 'more' ? 'less' : 'more');
    });
  },


  appendHtml: function(collectView, itemView) {
    this.$('.contained-channel-description').show();
    if(this.$('ul').children().length < 3 + 1) { // real children + overflow
      this.$('ul').prepend(itemView.el);
    } else {
      this.$('.overflow').append(itemView.el);
      $("#more-button").show();
    }
  },

  onRender: function(){
    if (this.collection.models.length == 0 ){
      this.$('.contained-channel-description').hide();
    }
  }

});

