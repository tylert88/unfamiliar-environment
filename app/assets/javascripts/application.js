// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require tablednd
//= require underscore
//= require zeroclipboard
//= require bootstrap-sprockets
//= require typeahead
//= require jquery.hotkeys
//= require tabby
//= require d3
//= require react
//= require react_ujs
//= require ace/ace
//= require ace/worker-html
//= require ace/theme-monokai
//= require ace/mode-javascript
//= require ace/mode-markdown
//= require components
//= require_tree .

if (window.google) { // allow public pages to not load google charts
  google.load("visualization", "1", {packages:["corechart", "timeline"]});
}

$(document).ready(function() {
  $(document).bind('keydown', '/', function () {
    $("[data-search]").focus();
    return false;
  });

  var menu = $('#navigation-menu');
  var menuToggle = $('#js-mobile-menu');

  $(menuToggle).on('click', function(e) {
    e.preventDefault();
    menu.slideToggle(function(){
      if(menu.is(':hidden')) {
        menu.removeAttr('style');
      }
    });
  });

  $('[data-tabby]').tabby();

  $(document).on("click", "[data-prevent-jump]", function(){
    return false;
  });

  $(document).on("click", "[data-behavior=stay-open-on-meta-click]", function(e){
    if (event.metaKey || event.which == 2) {
      e.stopPropagation();
    }
  });

  new ZeroClipboard($("[data-clipboard-text]"));

  $(document).on("click", "[data-behavior=score-form] :radio", function(e){
    if(this.value === '1' || this.value === '2') {
      $(this).closest('.panel').addClass('panel-warning').removeClass('panel-default').removeClass('panel-success')
    } else {
      $(this).closest('.panel').addClass('panel-success').removeClass('panel-default').removeClass('panel-warning')
    }
    $(this).closest('form').submit()
  });

  $('[data-toggle="popover"]').popover();
});

window.drawChart = function(title, data, elementId, color) {
  var data = google.visualization.arrayToDataTable(data);

  var options = {
    title: title,
    legend: { position: 'none' },
    colors: [color]
  };

  var chart = new google.visualization.Histogram(document.getElementById(elementId));
  chart.draw(data, options);
}

window.MentorshipForm = {
  initialize: function (data) {
    $(document).on("click", "[data-behavior=new-mentor]", function () {
      $("[data-container=new-only]").removeClass("hidden");
      $("[data-container=any]").removeClass("hidden");
      $("[data-container=new-only] input")
        .removeAttr("disabled")
        .prop("disabled", false)
        .val('');
      $("[data-container=existing-only]").addClass("hidden");

      $('#mentor_search').typeahead('val', '');
      $('#mentorship_mentor_id').val('');
      $('#user_first_name').focus();
    });

    $(document).on('typeahead:selected', '#mentor_search', function (e, data) {
      // hide the fields that only apply to new mentors
      $("[data-container=new-only]").addClass("hidden");
      $("[data-container=new-only] input")
        .attr("disabled", "disabled")
        .prop("disabled", true)
        .val('');

      // show the appropriate fields for an existing mentor
      $("[data-container=any]").removeClass("hidden");
      $("[data-container=existing-only]").removeClass("hidden");
      $("[data-placeholder=user-name]").text(data.full_name);

      $('#mentor_search').typeahead('val', '');
      $('#mentorship_company_name').focus();
      $('#mentorship_mentor_id').val(data.id);
      return false;
    });

    $(document).on('keypress', '#mentor_search', function (e) {
      if(e.keyCode === 13){
        return false;
      };
    });

    var engine = new Bloodhound({
      name: 'users',
      local: data,
      datumTokenizer: function(d) {
        return Bloodhound.tokenizers.whitespace(d.full_name.toLowerCase());
      },
      queryTokenizer: Bloodhound.tokenizers.whitespace
    });

    engine.initialize();

    var options = { minLength: 2, highlight: true };
    var dataSource = {
      displayKey: 'full_name',
      source: engine.ttAdapter(),
      templates: {
        empty: [
          '<div class="empty-message">',
          '<p>Unable to find any users that match.</p>',
          '<p class="text-center"><a href="#" class="btn btn-info" data-behavior="new-mentor">Enter a new one.</a></p>',
          '</div>'
        ].join('\n'),
      }
    }
    $('#mentor_search').typeahead(options, dataSource).focus();
    $('[data-container=all]').removeClass('hidden');
  }
}
