(function() {

  function InteractiveTour (opts) {
    var self = this,
        opts = $.merge(opts, {}),
        lastStep;

    var SHOW_HELP_TEXT_DELAY = 450;

    initialize();

    self.hoi = function hoi() {
      console.info("hoi");
    }

    function initialize () {
      showHelpText('step1');
    }

    function showHelpText (id) {
      $('.help-text-container > div').fadeOut('slow', function () {
        setTimeout(function () {
          $('#' + id).fadeIn('slow');
        }, SHOW_HELP_TEXT_DELAY);
      });
    }

    self.showHelpText = function aap(id) {
      showHelpText(id);
    }

    return self;
  }

  window.tour = new InteractiveTour({});

})();