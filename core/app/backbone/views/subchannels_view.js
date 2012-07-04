window.SubchannelsView = Backbone.Factlink.CompositeView.extend({
  tagName: "div",
  id: "contained-channels",
  template: 'channels/subchannels',
  itemView: SubchannelItemView,

  initialize: function() {
    this.collection.bind('remove', this.render, this);
  },

  appendHtml: function(collectView, itemView) {
    $('.contained-channel-description').show();
    if(this.$('ul').children().length < 3 + 1) { // real children + overflow
      this.$('ul').prepend(itemView.el);
    } else {
      this.$('.overflow').append(itemView.el);
      $("#more-button").show();
    }
  },

  onRender: function(){
    if (this.collection.models.length == 0 ){
      $('.contained-channel-description').hide();
    }
  }

});

