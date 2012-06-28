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
  if (this.onClose) {
    this.onClose();
  }
  this.trigger('close');
};

/*
window.bekijks={};
Backbone.View.prototype.constructor = function(options) {
  this.cid = _.uniqueId('view');
  console.info('+CID ', this.cid);
  window.bekijks[this.cid]=this;
     this._configure(options || {});
     this._ensureElement();
     this.initialize.apply(this, arguments);
     this.delegateEvents();
     this.on('close', function(){console.info('-CID', this.cid);delete window.bekijks[this.cid];},this);
}
*/