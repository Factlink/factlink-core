window.BaseFactWheelView = Backbone.View.extend({
  tagName: "div",
  className: "wheel",

  defaults: {
    dimension: 24,
    radius: 16,
    minimalVisiblePercentage: 15,
    defaultStroke: {
      opacity: 0.2,
      width: 9
    },
    hoverStroke: {
      opacity: 0.5,
      width: 11
    },
    userOpinionStroke: {
      opacity: 1.0
    }
  },

  initialize: function (options) {
    this.useTemplate("facts", "_fact_wheel");

    this.options = $.extend({}, this.defaults, options);

    this.opinionTypeRaphaels = {};
  },

  render: function () {
    var self = this;
    var offset = 0;

    this
      .$el.html('<div class="html_container"></div>').find('.html_container')
      .html(Mustache.to_html(this.tmpl, this.model.toJSON()));

    this.canvas = Raphael(this.el,
                          this.options.dimension * 2 + 17,
                          this.options.dimension * 2 + 17);

    this.bindCustomRaphaelAttributes();

    this.calculateDisplayablePercentages();

    this.model.opinionTypes.each(function(opinionType) {
      self.createOrAnimateArc(opinionType, offset);

      offset += opinionType.get("displayPercentage");
    });

    this.bindTooltips();

    return this;
  },

  reRender: function () {
    var self = this;
    var offset = 0;

    this
      .$el.find('.html_container')
      .html(Mustache.to_html(this.tmpl, this.model.toJSON()));

    this.calculateDisplayablePercentages();

    this.model.opinionTypes.each(function(opinionType) {
      self.createOrAnimateArc(opinionType, offset);

      offset += opinionType.get("displayPercentage");
    });

    this.bindTooltips();

    return this;
  },

  createOrAnimateArc: function (opinionType, percentageOffset) {
    var opacity = opinionType.get('is_user_opinion') ? this.options.userOpinionStroke.opacity : this.options.defaultStroke.opacity;
    // Our custom Raphael arc attribute
    var arc = [opinionType.get('displayPercentage'), percentageOffset, this.options.radius];

    if ( ! this.opinionTypeRaphaels[opinionType.get("type")] ) {
      this.createArc(opinionType, arc, opacity);
    } else {
      this.animateExistingArc(opinionType, arc, opacity);
    }
  },

  createArc: function (opinionType, arc, opacity) {
    // Create a path in the global Raphael canvas and store it in opinionTypeRaphaels
    var path = this.canvas.path().attr({
      // Our custom arc attribute
      arc: arc,
      stroke: opinionType.get("color"),
      "stroke-width": this.options.defaultStroke.width,
      opacity: opacity
    });

    // Bind Mouse Events on the path
    path.mouseover( _.bind(this.mouseoverOpinionType, this, path, opinionType) );
    path.mouseout( _.bind(this.mouseoutOpinionType, this, path, opinionType) );
    path.click( _.bind(this.clickOpinionType, this, opinionType) );

    this.opinionTypeRaphaels[opinionType.get("type")] = path;
  },

  animateExistingArc: function (opinionType, arc, opacity) {
    // Retrieve the existing Raphael path belonging to this opinionType
    this.opinionTypeRaphaels[opinionType.get("type")].animate({
      // Our custom arc attribute
      arc: arc,
      opacity: opacity
    }, 200, '<>');
  },

  // This method also commits the calculated percentages to the model, maybe return instead?
  calculateDisplayablePercentages: function () {
    var self = this;
    var too_much = 0;
    var large_ones = 0;

    this.model.opinionTypes.each(function(opinionType) {
      var percentage = opinionType.get('percentage');

      if ( percentage < self.options.minimalVisiblePercentage ) {
        too_much += self.options.minimalVisiblePercentage - percentage;
      } else if ( percentage > 40 ) {
        large_ones += percentage;
      }
    });

    this.model.opinionTypes.each(function(opinionType) {
      var percentage = opinionType.get('percentage');

      if ( percentage < self.options.minimalVisiblePercentage ) {
        percentage = self.options.minimalVisiblePercentage;
      } else if ( percentage > 40 ) {
        percentage = percentage - ( ( percentage / large_ones ) * too_much );
      }

      opinionType.set('displayPercentage', percentage);
    });
  },

  bindCustomRaphaelAttributes: function () {
    var self = this;

    this.canvas.customAttributes.arc = function(percentage, percentageOffset, radius) {
      percentage = percentage - 2; // add padding after arc

      var largeAngle = percentage > 50;
      var boxDimension = self.options.dimension + 6;
      var startAngle = percentageOffset * 2 * Math.PI / 100;
      var endAngle = (percentageOffset + percentage) * 2 * Math.PI / 100;
      var startX = boxDimension + radius * Math.cos(startAngle);
      var startY = boxDimension - radius * Math.sin(startAngle);
      var endX = boxDimension + radius * Math.cos(endAngle);
      var endY = boxDimension - radius * Math.sin(endAngle);

      return {
        path: [
          ['M', startX, startY],
          ['A', radius, radius, 0, (largeAngle ? 1 : 0), 0, endX, endY]
        ]
      };
    }
  },

  mouseoverOpinionType: function (path, opinionType) {
    var destinationOpacity = this.options.hoverStroke.opacity;

    if ( opinionType.get("is_user_opinion") ) {
      destinationOpacity = this.options.userOpinionStroke.opacity;
    }

    path.animate({
      'stroke-width': this.options.hoverStroke.width,
      opacity: destinationOpacity
    }, 200, "<>");
  },

  mouseoutOpinionType: function (path, opinionType) {
    var destinationOpacity = this.options.defaultStroke.opacity;

    if ( opinionType.get("is_user_opinion") ) {
      destinationOpacity = this.options.userOpinionStroke.opacity;
    }

    path.animate({
      'stroke-width': this.options.defaultStroke.width,
      opacity: destinationOpacity
    }, 200, "<>");
  },

  clickOpinionType: function () {},

  bindTooltips: function () {
    var self = this;

    this.$el.find('.authority').tooltip({
      title: "This number represents the amount of thinking "
           + "spent by people on this Factlink"
    });

    // Create tooltips for each opinionType (believe, disbelieve etc)
    this.model.opinionTypes.each(function(opinionType) {
      var raphaelObject = self.opinionTypeRaphaels[opinionType.get('type')];

      $( raphaelObject.node ).tooltip({
        title: opinionType.get('groupname') + ": " + opinionType.get("percentage") + "%",
        placement: "left"
      });
    });
  },

  updateTo: function (authority, opinionTypes) {
    this.model.set('authority', authority );

    if ( _.isArray( opinionTypes ) ) {
      var tempObject = {};

      _.each(opinionTypes, function (opinionType) {
        tempObject[opinionType.type] = opinionType;
      });

      opinionTypes = tempObject;
    }

    this.model.opinionTypes.each(function(opinionType) {
      var newOpinionType = opinionTypes[opinionType.get('type')];

      opinionType.set('percentage', newOpinionType.percentage);
      opinionType.set('is_user_opinion', newOpinionType.is_user_opinion);
    });

    this.reRender();
  },

  //TODO: End of the day hacking going on, check later
  toggleActiveOpinionType: function (opinionType) {
    var oldAuthority = this.model.get("authority");
    var updateObj = {};

    this.model.opinionTypes.each(function(oldOpinionType) {
      updateObj[oldOpinionType.get('type')] = oldOpinionType.toJSON();

      if ( ! opinionType.get('is_user_opinion') ) {
        updateObj[oldOpinionType.get('type')].is_user_opinion = false;
      }

      if ( oldOpinionType === opinionType ) {
        updateObj[oldOpinionType.get('type')].is_user_opinion = ! opinionType.get('is_user_opinion');
      }
    });

    this.updateTo(oldAuthority, updateObj);
  }
});
