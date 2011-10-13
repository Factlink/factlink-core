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
  
  $('div.search>form').live('ajax:beforeSend', function() {
      setLoadingEvidence($(this));
    
      searchString = $(this, 'input.evidence_search').val();
    }).live('ajax:success', function() {
      window.isFullyLoaded = false;
      stopLoadingEvidence($(this));
    });
  
  // Check if all Factlinks are loaded
  $('div.tab_content').data('isFullyLoaded', false);

  $('div.evidence-list').infiniScroll({
    isFullyLoaded: function() {
      return $('div.tab_content:visible', this).data('isFullyLoaded');
    },
    
    check_scroll: function() {
      if ($('div.tab_content:visible', this).height() - (this.scrollTop() + this.height()) < 250) {
        return true;
      }
    },

    url: function(page) {
      var fact = $( 'div.fact-block' );
      
      var search = ($('div.tab_content:visible', this).is('[rel=evidence-for]') ? "evidence_search" : "evidenced_search");
      
      return '/facts/' + fact.data('fact-id') + '/' + search + '/page/' + page + '.js' + (searchString ? "?s=" + searchString : "");
    }
  });

})();