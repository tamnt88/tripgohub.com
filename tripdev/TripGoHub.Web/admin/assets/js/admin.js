$(function () {
  $('.menu-toggle').on('click', function () {
    var targetId = $(this).data('target');
    var group = $(this).closest('.menu-group');
    var list = $('#' + targetId);
    group.toggleClass('is-open');
    list.slideToggle(120);
  });
});
