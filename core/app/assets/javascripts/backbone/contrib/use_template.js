/*
    View.useTemplate() method which loads the mustache templates

    call this in the initialize()
*/
Backbone.View.prototype.useTemplate = function(dir,file) {
  if (this.tmpl !== undefined) {
    return;
  }

  var self = this;
  this.tmpl = $('#mustache-templates .mustache-dir-'+dir+".mustache-file-"+file).html();
  this.partials = {};
  $('#mustache-templates .mustache-dir-'+dir).each(function(index, element){
    var filename = $(element).data('filename').replace(/^_/,'');
    self.partials[filename] = $(element).html();
  });
};