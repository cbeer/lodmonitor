$(function() {
  $('.add-resource').on('click', function(event) {
    event.preventDefault();

    var counter = $(this).parent().find('.form-group').length + 1;

    var group = $($.parseJSON($(this).data('resource')).replace(/0/g, counter)).insertBefore(this);
    group.find('input').focus();
  });
});