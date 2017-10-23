$(function(){
  $(".previous-plans").on("click", function(e) {
    $("#previous-plans").toggle();
    $("#todays-plan").toggle();
    e.preventDefault();
  });
});