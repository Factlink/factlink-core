/*
    View.close() method which makes sure the View is propperly destroyed, and
    the events are unbound
    
    Also triggers a nice close event!
    
    This method is needed to make sure we don't get any zombie views that don't
    exist in the users view, but are still bound to events (like user 
    interaction events or model events)
*/
Backbone.View.prototype.close = function() {
  this.remove();
  this.unbind();
  
  this.trigger('close');
};


/*
    View.useTemplate() method which loads the mustache templates

    call this in the initialize()
*/
Backbone.View.prototype.useTemplate = function(dir,file) {
  var self = this;
  this.tmpl = $('#mustache-templates .mustache-dir-'+dir+".mustache-file-"+file).html();
  this.partials = {};
  $('#mustache-templates .mustache-dir-'+dir).each(function(index, element){
    var filename = $(element).data('filename').replace(/^_/,'');
    self.partials[filename] = $(element).html();
  });
};
