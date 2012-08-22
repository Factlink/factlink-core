(function() {
window.PersistentWheelView = BaseFactWheelView.extend({
  clickOpinionType: function (opinionType, e) {
    if ( parent.parent ) {
      parent.parent.FACTLINK.opinionSet();
    }

    this.updateTo("1.0", {
      believe: getHash(opinionType.get('type'), "believe"),
      disbelieve: getHash(opinionType.get('type'), "disbelieve"),
      doubt: getHash(opinionType.get('type'), "doubt")
    });

    $('input[name=opinion][value=' + opinionType.get('type') + 's]')
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
