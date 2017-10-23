window.Assessment = {

  trackFocus: true,

  preventUnload: true,

  nonAssessmentLinkClicked: false,

  initialize: function(options){

    var message = '----- Whoa! -----\n\n' +
      '  You are taking a Galvanize assessment.  You probably should not be here ;->\n\n' +
      '----------';

    this.trackingUrl = options.trackingUrl;

    $(document).on('click', '[data-cancel-unload]', function(){
      this.preventUnload = false;
    }.bind(this));

    $(document).on('click', '[data-cancel-tracking]', function(){
      this.trackFocus = false;
    }.bind(this));

    $(document).on('click', 'a:not([data-cancel-tracking])', function(e){
      this.nonAssessmentLinkClicked = true;
    }.bind(this));

    $(window).on('beforeunload', function () {
      if (this.nonAssessmentLinkClicked) {
        $.post(this.trackingUrl, {'event': 'Non-assessment link clicked'});
      }
      if (this.preventUnload) {
        return "You have not saved your assessment!";
      }
    }.bind(this));

    $(window).on("blur", function(){
      if (this.trackFocus) {
        $.post(this.trackingUrl, {'event': 'Browser lost focus'})
      }
    }.bind(this));

  }

};
