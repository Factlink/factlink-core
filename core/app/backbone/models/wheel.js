window.Wheel = Backbone.Model.extend({
	initialize: function () {
		this.opinionTypes = new OpinionTypes(this.get('opinion_types'));
	},

	// Overwrite default toJSON method so it also adds this.opinionTypes
	toJSON: function () {
		var originalAttributes = Backbone.Model.prototype.toJSON.apply(this);
		var newAttributes = _.extend(originalAttributes, {
			opinion_types: this.opinionTypes.toJSON()
		});

		return _.clone(newAttributes);
	}
});
