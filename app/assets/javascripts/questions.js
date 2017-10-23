$(function(){
  $('.add-new-question').on('click', function(e) {
    e.preventDefault();
    var $questionForm = $('.question-form').first();
    var $questionFormClone = $questionForm.clone();
    var formsOnPage = $('.question-form').length;

    $questionFormClone.find('label').each(function() {
      var oldLabel = $(this).attr('for');
      var newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), '_' + formsOnPage + '_')
      $(this).attr('for', newLabel);
    });

    $questionFormClone.find('select, input, textarea').each(function() {
      var oldId = $(this).attr('id');
      var newId = oldId.replace(new RegExp(/_[0-9]+_/), '_' + formsOnPage + '_');
      $(this).attr('id', newId);

      oldName = $(this).attr('name');
      newName = oldName.replace(new RegExp(/\[[0-9]+\]/), '[' + formsOnPage + ']');
      $(this).attr('name', newName);
    });

    $questionFormClone.find('input:text, input:password, input:file, select, textarea').val('');
    $questionFormClone.find('input:radio, input:checkbox').removeAttr('checked').removeAttr('selected');
    $questionFormClone.appendTo($questionForm.parent());
  });
});

