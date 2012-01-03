(function($) {
  var methods = {
    // Initialize factbubble
    init: function(options) {
      return this.each(function() {
        function stop_fade(t) {
          t.stop(true, true).css({
            "opacity": "1"
          });
        }

        function addEventHandlersTabs($fact) {
          $fact.find("ul.evidence li").click(function() {

            if ($fact.find(".dropdown-container").is(":hidden")) {
              $fact.find(".dropdown-container").slideDown();

              // AJAX call to load the FactRelations
              if (!$fact.data('loaded-evidence')) {
                getEvidence($fact);
                $fact.data('loaded-evidence', true);
              }

              $(this).addClass("active");
              $fact.addClass("active");

            } else {
              if ($(this).hasClass("active")) {
                $fact.find(".dropdown-container").slideUp(function() {
                  $fact.find("ul.evidence li").removeClass("active");
                  $fact.removeClass("active");
                });
              } else {
                $fact.find("ul.evidence li").removeClass("active");
                $(this).addClass("active");
                $fact.addClass("active");
              }
            }
            return false;
          });
        }

        function initialize($fact) { /* based on http://www.sohtanaka.com/web-design/simple-tabs-w-css-jquery/ */
          //On Click Event
          addEventHandlersTabs($fact);

          $fact.data('loaded-evidence', false);

          $fact.bind("factlink:switchTabAction", function(e, active) {
            switchTabAction(active);
          });
          // Evidence buttons
          $fact.find(".existing_evidence a").live("ajax:complete", function(et, e) {
            $(this).closest('ul').children().find('a').removeClass("active");
            $(this).addClass('active');
          });
          $fact.data("initialized", true);
        } /*start of method*/
        var $fact = $(this);
        $fact.data("facts", {});
        if (!$fact.data("initialized")) {
          initialize($fact);
        }
        $fact.find("article.fact").each(function() {
          var fact = init_fact(this, $fact);
          $fact.data("facts")[fact.attr("data-fact-id")] = fact;
        });
      });
    },

    update: function(data) {
      var $fact = $(this).data("container") || $(this);
      if ($fact.data("initialized")) {
        $(data).each(function() {
          var fact = $fact.data("facts")[this.id];
          if (fact && $(fact).data("initialized")) {
            $(fact).data("update")(this.score_dict_as_percentage); // Update the facts
          }
        });
      }
    },
    switch_opinion: function(opinion) {
      var fact = this,
          opinions = fact.data("wheel").opinions;
      opinions.each(function() {
        var current_op = this;
        if ($(current_op).data("opinion") === opinion.data("opinion")) {
          if (!$(current_op).data("user-opinion")) {
            $.post("/facts/" + $(fact).data("fact-id") + "/opinion/" + opinion.data("opinion") + ".json", function(data) {
              data_attr(current_op, "user-opinion", true);
              fact.factlink("update", data);
            });
          }
          else {
            $.ajax({
              type: "DELETE",
              url: "/facts/" + $(fact).data("fact-id") + "/opinion.json",
              success: function(data) {
                data_attr(current_op, "user-opinion", false);
                fact.factlink("update", data);
              }
            });
          }
        }
        else {
          data_attr(current_op, "user-opinion", false);
        }
      });
    },


    to_channel: function(user, channel, fact) {
      $.ajax({
        url: "/" + user + "/channels/toggle/fact",
        dataType: "script",
        type: "POST",
        data: {
          user: user,
          channel_id: channel,
          fact_id: fact
        }
      });
    }
  };

  $.fn.factlink = function(method) {
    // Method calling logic
    if (methods[method]) {
      return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    }
    else if (typeof method === 'object' || !method) {
      return methods.init.apply(this, arguments);
    }
    else {
      $.error('Method ' + method + ' does not exist on jQuery.factlink');
    }
  };

  // Private functions
  function data_attr(el, attr, data) {
    $(el).attr("data-" + attr, data);
    $(el).data(attr, data);
  }

  function getEvidence($fact) {
    var id = $fact.attr("data-fact-id");
    var loader = $fact.find('.loading-evidence');
    $.ajax({
      url: '/facts/' + id + '/fact_relations',
      type: "GET",
      dataType: "script",
      success: function(data) {
        loader.hide();
      },
      error: function(data) {}
    });
  }

  function submitEvidence($c, type) {

    var factId = $c.attr("data-fact-id");
    var evidenceId = $c.data("evidence-id");
    var url_part;

    if (type === "supporting") {
      url_part = "/add_supporting_evidence/";
    } else if (type === "weakening") {
      url_part = "/add_weakening_evidence/";
    } else {
      alert('There is a problem adding the evidence to this Factlink. We are sorry for the inconvenience, please try again later.');
    }

    // TODO: This should changed to use the FactRelationController
    $.ajax({
      url: "/factlink/" + factId + url_part + evidenceId,
      type: "post",
      dataType: "script",
      success: function() {
        resetSearch($c);
      },
      error: function() {
        console.log('Adding evidence failed: ' + "/factlink/" + factId + url_part + evidenceId);
      }
    });
  }

  function submitNewEvidence($c, type) {
    var factId = $c.attr("data-fact-id");
    var displayString = $($c.find(".fact_data_displaystring")).val();
    var url_part;

    // Little client side validation on the displaystring length
    var displaystring_input_field = $c.find('.fact_data_displaystring');

    if (displaystring_input_field.val().length < 1) {
      displaystring_input_field.css('border', 'solid 1px rgba(206, 0, 0, 0.6)').attr("placeholder", "This field is required");
      return false;
    }

    if (type === "supporting") {
      url_part = "/supporting_evidence/";
    } else if (type === "weakening") {
      url_part = "/weakening_evidence/";
    } else {
      alert('There is a problem adding the evidence to this Factlink. We are sorry for the inconvenience, please try again later.');
    }

    $.ajax({
      url:      "/facts/" + factId + url_part,
      type:     "post",
      dataType: "script",
      data:   {
                displaystring: displayString,
                type: type
              },
      success: function(data) {
        resetSearch($c);
      },
      error: function(data) {
      }
    });
  }

  function init_fact(fact, container) {
    var $fact = $(fact);
    var $c = $(container);
    if (!$fact.data("initialized")) {
      $fact.find('.edit').editable('/facts/update_title', {
        indicator: 'Saving...',
        tooltip: 'Click to add a title to this Factlink',
        placeholder: "Add title",
        width: "380"
      });

      $fact.data("container", container);
      $fact.data("wheel", new Wheel(fact));
      $fact.data("wheel").init($fact.find(".wheel").get(0));


      // Now setting a function in the jquery data to keep track of it, would be prettier with custom events
      $fact.data("update", function(data) {
        $fact.data("wheel").opinions.each(function() {
          data_attr(this, "value", data[$(this).data("opinions")].percentage);
        });
        data_attr($fact.data("wheel").authority,"authority",data.authority);
        $fact.data("wheel").update();
      });

      $fact.data("initialized", true);
    }
    return $fact;
  }
})(jQuery);
