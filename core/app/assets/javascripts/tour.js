(function() {

  function InteractiveTour () {

    var self = this;
    var SHOW_HELP_TEXT_DELAY = 560;

    initialize();

    function initialize () {
      self.lastStep    = 0;
      self.currentStep = 0;

      showStep(1);
    }

    function showStep(id) {
      self.lastStep = self.currentStep;
      self.currentStep = id;

      if ((self.lastStep !== self.currentStep) && (self.lastStep < self.currentStep) ) {
        showHelpText(id);
      }
    }

    function showHelpText () {
      $('.help-text-container > div').fadeOut('slow', function () {
        setTimeout(function () {
          $('#step' + self.currentStep).fadeIn('slow');
        }, SHOW_HELP_TEXT_DELAY);
      });
    }

    self.showStep = showStep;

    return self;
  }

  window.tour = new InteractiveTour({});

})();