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
    var evidence_type = "weakening_evidence";

    if ( this.get('fact_relation_type') === "believing" ) {
      evidence_type = "supporting_evidence";
    }

    return this.collection.fact.url() + "/" + evidence_type + "/" + this.get('id');
  }
});