(function(){
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
  }).bind('ajax:success', function() {
    stopLoadingEvidence($(this));
  });
})();