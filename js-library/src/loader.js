(function( Factlink ) {

var // Store the Loader object in the prototype
    Loader = Factlink.prototype.Loader = {
    // jQuery object which holds the loader
    el : $( '<div class="loader">' +
                '<h1>Factlink</h1>' +
                '<p id="fl-status">Loading Factlink sources</p>' +
                '<ul class="fl-status-list"></ul>' +
            '</div>' )
};

Loader.init = function() {
    // Do some initilizing
    this.el
        .hide()
        .appendTo('body');
};

// Open the dialog
Loader.open = function() {
    // Show the loader
    this.el.show();
};

// Update the current status
Loader.updateStatus = function(status) {
        // The status list
    var $statuslist = this.el.find('.fl-status-list');
    
    // Add the status to the list
    $statuslist.append('<li class="hide">' + status + '</li>');
    
    $statuslist.find(':not(.hide)').fadeOut('fast', function(){
        $( this ).addClass('hide').next('li').fadeIn('fast', function(){
            $(this).removeClass('hide');
        });
    });
};

// Loading is finished, dialog is dissmissed
Loader.finish = function() {
    // Hide the loader
    this.el.fadeOut();
};

})( Factlink );