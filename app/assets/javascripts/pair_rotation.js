var PairRotation = {

  index: 0,

  init: function () {
    $('[data-behavior=select-user]').on('click', function (e) {
      if($('[data-behavior=select-user]:checked').length === 2) {
        $('[data-behavior=select-user]:not(:checked)')
          .prop('disabled', true)
          .attr('disabled', 'disabled');
      } else {
        $('[data-behavior=select-user]:not(:checked)')
          .prop('disabled', false)
          .removeAttr('disabled');
      }
    }.bind(this));

    $('[data-behavior=pair-users]').on('click', function () {
      var pair1 = $('[data-behavior=select-user]:checked').get(0);
      var pair2 = $('[data-behavior=select-user]:checked').get(1);

      $('[data-behavior=select-user]:checked').closest('.checkbox').remove();

      var $tr = $('<tr>');
      $tr.append(this.makeCell($(pair1)));
      $tr.append(this.makeCell($(pair2)));

      $('[data-placeholder=pairs]').append($tr);

      $('[data-behavior=select-user]')
        .prop('disabled', false)
        .removeAttr('disabled');

      this.index++;
      return false;
    }.bind(this));
  },

  makeCell: function ($pair) {
    var $td = $('<td>');
    $td.html($pair.data('full-name'));
    var $input = $('<input type="hidden">');
    $input.attr('name', 'pairs[' + this.index + '][]');
    $input.val($pair.data('user-id'));
    $td.append($input);
    return $td;
  }

};
