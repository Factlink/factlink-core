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

        function switchTabAction(active) {
          $fact.find(".tab_content[rel=" + active + "] .add-evidence").toggle();
          $fact.find(".tab_content[rel=" + active + "] .evidence").toggle();
          var action = $fact.find(".add-action[rel=" + active + "] > a");
          action.text($(action).text() === 'Add facts' ? 'Show facts' : 'Add facts');
        }

        function addEventHandlersDoAdd($fact) {
          $fact.find("a.do-add").live("click", function() {
            resetSearch($fact);
            $fact.find('.evidence-list').hide();
            $fact.find('.evidence-search-results').show();
            return false;
          });
        }

        function addEventHandlersBackToEvidenceListing($fact) {
          $fact.find("a.back-to-evidence-listing").bind("click", function() {
            showEvidenceList($fact);
            resetSearch($fact);
            return false;
          });
        }

        function addEventHandlersBackToSearch($fact) {
          $fact.find("a.back-to-search").bind("click", function() {
            $fact.find('.page').hide();
            $fact.find('.evidence-search-results').show();
            return false;
          });
        }

        function bindEvidenceAddButtons($fact) {
          $fact.find('.evidence-add button.supporting').bind('click', function() {
            submitEvidence($fact, "supporting");
          });

          $fact.find('.evidence-add button.weakening').bind('click', function() {
            submitEvidence($fact, "weakening");
          });
        }
        
        function bindNewEvidenceAddButtons($fact) {
          $fact.find('.new-evidence-add button.supporting').bind('click', function() {
            submitNewEvidence($fact, "supporting");
          });

          $fact.find('.new-evidence-add button.weakening').bind('click', function() {
            submitNewEvidence($fact, "weakening");
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

            } else {
              if ($(this).hasClass("active")) {
                $fact.find(".dropdown-container").slideUp(function() {
                  $fact.find("ul.evidence li").removeClass("active");
                });
              } else {
                $fact.find("ul.evidence li").removeClass("active");
                $(this).addClass("active");
              }
            }
            return false;
          });
        }

        function initialize($fact) { /* based on http://www.sohtanaka.com/web-design/simple-tabs-w-css-jquery/ */
          //On Click Event
          addEventHandlersTabs($fact);
          addEventHandlersDoAdd($fact);
          addEventHandlersBackToEvidenceListing($fact);
          addEventHandlersBackToSearch($fact);

          bindEvidenceAddButtons($fact);
          bindNewEvidenceAddButtons($fact);

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

        // Prevents boxes from dissapearing on mouse over
        $fact.find(".float-box").mouseover(function() {
          stop_fade($(this));
        });
        $fact.find(".float-box").mouseout(function() {
          if (!$(this).find("input#channel_title").is(":focus")) {
            $(this).delay(500).fadeOut("fast");
          }
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
    },
    getChannelChecklist: function(fact) {
      var id = fact.attr("data-fact-id");
      fact.find(".add-to-channel").off('hover.load_channel_list');

      $.ajax({
        url: '/facts/' + id + '/channels',
        type: "GET",
        dataType: "html",
        success: function(data) {fact.find(".channel-listing").html(data);},
        error: function(data) {}
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

  function bindNewEvidenceAddAction($c) {
    $c.find('.new-evidence-add-action').bind('click', function() {
      showNewEvidenceAdd($c);
      // Populate the input field
      var currentInput = $c.find('input.evidence_search').val();
      $c.find("#fact_data_displaystring").val(currentInput);
    });
  }
  function bindEvidencePrepare($c) {
    $c.find('.results ul li.evidence').live('click', function() {
      showEvidenceAdd($c);

      var elem = $(this);
      var evidenceId = elem.data('evidence-id');
      var evidenceDisplayString = elem.html();

      // Set the evidence ID used for posting
      $c.data('evidenceId', evidenceId);

      // Set the displaystring to the evidence bubble
      $c.find('.evidence-add .evidence').html(evidenceDisplayString);
    });
  }

  function submitEvidence($c, type) {
    
    console.info("submitting evidence");
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
    var displayString = $($c.find("#fact_data_displaystring")).val();
    var url_part;

    if (type === "supporting") {
      console.info('add as supporting');
      url_part = "/supporting_evidence/";
    } else if (type === "weakening") {
      console.info('add as weakening');
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

  function bindInstantSearch($c) {
    var is_timeout;
    $c.find('.search-area .evidence_search').keyup(function() {
      showSearchResults($c);
      
      var elem = $(this);
      $('.user-search-input').text(elem.val());

      if (elem.val().length >= 2) {
        
        showAddOptions($c);
        
        clearTimeout(is_timeout);
        is_timeout = setTimeout(function() {
          elem.closest('form').submit();
        }, 200); // <-- choose some sensible value here        
      } else {
        hideSearchResults($c);
        hideAddOptions($c);
      }
    });
  }


  function showEvidenceList($c) {
    hidePages($c);
    $c.find('.evidence-list').show();
  }

  function showEvidenceSearchResults($c) {
    hidePages($c);
    $c.find('.evidence-search-results').show();
  }

  function showEvidenceAdd($c) {
    hidePages($c);
    $c.find('.evidence-add').show();
  }
  
  function showNewEvidenceAdd($c) {
    hidePages($c);
    $c.find('.new-evidence-add').show();
  }

  function hidePages($c) {
    $c.find('.page').hide();
  }
  
  function resetSearch($c) {
    hideSearchResults($c);
    hideAddOptions($c);
    $c.find('.search-and-add-actions').hide();
    $c.find('.search-area .evidence_search').val('');
  }
  function showSearchResults($c) {
    $c.find('.evidence-search-results .search-term-results').show();
    $c.find('.evidence-search-results .default-results').hide();
  }
  function hideSearchResults($c) {
    $c.find('.evidence-search-results .search-term-results').hide();
    $c.find('.evidence-search-results .default-results').show();
  }
  
  function showAddOptions($c) {
    $c.find('.search-and-add-actions:hidden').fadeIn(100);
  }
  function hideAddOptions($c) {  
    $c.find('.search-and-add-actions').fadeOut(100, function() {
      $('.user-search-input').html('');
    });
  }


  function init_fact(fact, container) {
    var $fact = $(fact);
    var $c = $(container);
    if (!$fact.data("initialized")) {
      $fact.find('.edit').editable('/facts/update_title', {
        indicator: 'Saving...',
        tooltip: 'You can edit this title to place the Factlink in the correct context.'
      });

      $fact.data("container", container);
      $fact.data("wheel", new Wheel(fact));
      $fact.data("wheel").init($fact.find(".wheel").get(0));

      bindEvidencePrepare($c);
      bindNewEvidenceAddAction($c);
      bindInstantSearch($c);

      // Channels are in the container
      $fact.find(".add-to-channel")
        .on('hover.load_channel_list',function(){$().factlink('getChannelChecklist',$fact);})
        .hoverIntent(function(e) {
          var channelList = $fact.find(".channel-listing");
          $(channelList).fadeIn("fast");
      }, function() {
        $fact.find(".channel-listing").delay(600).fadeOut("fast");
      }).bind('click', function(e) {
        e.preventDefault();
      });

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
