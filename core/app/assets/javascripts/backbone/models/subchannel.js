window.Subchannel = Channel.extend({
  url : function() {
    return this.id;
  }
});