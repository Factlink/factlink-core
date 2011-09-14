$("a[data-onloadingtext]").live("ajax:before", function(et, e){
  $(this).text($(this).attr('data-onloadingtext'))
         .attr('onclick','return false;')
         .addClass('disabled');
});
$("a[data-oncompletetext]").live("ajax:complete", function(et, e){
  $(this).text($(this).attr('data-oncompletetext'));
});
