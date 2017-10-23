var Imports = {

  emailAlert: function () {
    function loggy() {
      if ($("#invitation_type").val()) {
        $("#email-alert").show();
      } else {
        $("#email-alert").hide();
      }
    };
    $("#invitation_type").change(loggy);
    loggy();
  }
};
