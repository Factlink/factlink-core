window.FactRelation = Backbone.Model.extend({
  setOpinion: function(type) {
    var self = this;

    $.ajax({
      url: this.url() + "/opinion/" + type,
      success: function(data) {
        self.set(data[0]);
      },
      type: "post"
    });
  },

  believe: function() {
    this.setOpinion("believes");
  },

  disbelieve: function() {
    this.setOpinion("disbelieves");
  },

  url: function() {
    return "/evidence/" + this.get('id');
  }
});