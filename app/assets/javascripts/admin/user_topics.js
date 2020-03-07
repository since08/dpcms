$(function () {
  $('.group').click(function() {
    var group = this.dataset.group;
    $('.group' + group).colorbox({
      rel: 'group' + group,
      transition: 'none'
    });
  });
});
