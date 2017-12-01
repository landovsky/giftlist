$(document).on('turbolinks:load', function() {
  i=$("#invitations")
  $("#invitation_btn").on("click", function() {
  if(i.is(":visible")) {
  i.hide(200);
  event.preventDefault();
  } else {
  i.show(200);
  event.preventDefault();
  }
  });
 });