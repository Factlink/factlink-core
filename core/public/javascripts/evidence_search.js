(function(){
  var searchString = "";
  
  function setLoadingEvidence($form) {
    $form.closest('div.add-evidence')
      .addClass('loading')
      .find('table.search-list').empty();
  }
  
  function stopLoadingEvidence($form) {
    $form.closest('div.add-evidence').removeClass('loading');
  }
  
  $('div.search>form').bind('ajax:beforeSend', function() {
    setLoadingEvidence($(this));
    
    searchString = $(this, 'input.evidence_search').val();
  }).bind('ajax:success', function() {
    stopLoadingEvidence($(this));
  });
  
  // Check if all Factlinks are loaded
  window.isFullyLoaded = false;

  $('div.evidence-list').infiniScroll({
    isFullyLoaded: function() {
      return window.isFullyLoaded;
    },
    
    check_scroll: function() {
      if ($('div.tab_content', this).height() - (this.scrollTop() + this.height()) < 250) {
        return true;
      }
    },

    url: function(page) {
      var fact = $( 'div.fact-block' );
      
      return '/facts/' + fact.data('fact-id') + '/evidence_search/page/' + page + '.js' + (searchString ? "?s=" + searchString : "");
    }
  });

})();