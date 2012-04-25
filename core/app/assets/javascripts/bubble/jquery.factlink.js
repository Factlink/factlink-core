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

        function initialize($fact) {
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
            // Pre-set the user-opinion, so we don't have to wait till the request is finished
            $( current_op ).realData("user-opinion", true);

            $.ajax({
              url: "/facts/" + $(fact).data("fact-id") + "/opinion/" + opinion.data("opinion") + ".json",
              type: "POST",
              success: function(data) {
                fact.factlink("update", data);

                try {
                  mpmetrics.track("Factlink: Opinionate", {
                    factlink: $(fact).data('fact-id'),
                    opinion: opinion.data("opinion")
                  });
                } catch(e) {}
              },
              error: function() {
                $(current_op).realData("user-opinion", false);

                fact.data('wheel').update();

                alert("Something went wrong while setting your opinion on the Factlink, please try again");
              }
            });
          }
          else {
            $(current_op).realData('user-opinion', false);

            $.ajax({
              type: "DELETE",
              url: "/facts/" + $(fact).data("fact-id") + "/opinion.json",
              success: function(data) {
                fact.factlink("update", data);

                try {
                  mpmetrics.track("Factlink: De-opinionate", {
                    factlink: $(fact).data('fact-id')
                  });
                } catch(e) {}
              },
              error: function() {
                $(current_op).realData("user-opinion", true);

                fact.data('wheel').update();

                alert("Something went wrong while removing your opinion on the Factlink, please try again");
              }
            });
          }
        }
        else {
          $(current_op).realData("user-opinion", false);
        }
      });

      fact.data("wheel").update();
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

  $.fn.realData = function (attr, data) {
    $(this).attr('data-' + attr, data);
    $(this).data(attr, data);
  };

  function init_fact(fact, container) {
    var $fact = $(fact);
    var $c = $(container);
    if (!$fact.data("initialized")) {
      $fact.data("container", container);
      $fact.data("wheel", new Wheel(fact));
      $fact.data("wheel").init($fact.find(".wheel").get(0));


      // Now setting a function in the jquery data to keep track of it, would be prettier with custom events
      $fact.data("update", function(data) {
        $fact.data("wheel").opinions.each(function() {
          $(this).realData("value", data[$(this).data("opinions")].percentage)
        });
        $fact.data("wheel").authority.realData("authority", data.authority);
        $fact.data("wheel").update();
      });

      $fact.data("initialized", true);
    }
    return $fact;
  }
})(jQuery);
