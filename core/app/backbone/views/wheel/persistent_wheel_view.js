(function() {
window.PersistentWheelView = BaseFactWheelView.extend({
  clickOpinionType: function (opinionType, e) {
    this.trigger('opinionSet');

    this.updateTo("1.0", {
      believe: getHash(opinionType.type, "believe"),
      disbelieve: getHash(opinionType.type, "disbelieve"),
      doubt: getHash(opinionType.type, "doubt")
    });

    $('input[name=opinion][value=' + opinionType.type + 's]')
      .prop('checked', true);
  }
});

function getHash(selectedType, type) {
  if ( selectedType == type ) {
    return selected;
  } else {
    return notSelected;
  }
}

var selected = {
  percentage: 100,
  is_user_opinion: true
};

var notSelected = {
  percentage: 0,
  is_user_opinion: false
};

}());
