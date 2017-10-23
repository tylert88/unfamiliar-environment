$(document).ready(function() {
  $("[data-editor]").each(function () {
    var $textarea = $(this)
    var editorId = $textarea.attr('id') + '-editor'
    console.log($textarea.height());
    var $editor = $('<div>', {
      id: editorId
    })
    $textarea.after($editor)
    $textarea.hide()

    var editor = ace.edit(editorId)
    editor.getSession().setValue($textarea.val());
    editor.getSession().setMode("ace/mode/" + $textarea.data('editor'));
    if ($textarea.attr('autofocus')) {
      editor.focus()
    }
    editor.getSession().setUseSoftTabs(true);
    editor.getSession().setUseWrapMode(true);
    editor.getSession().setWrapLimitRange();
    editor.getSession().on('change', function(e) {
      $textarea.val(editor.getValue())
    });
    editor.setOptions({
      minLines: $textarea.attr('rows') || 10,
      maxLines: 80
    });
  })

  if ($("#editor").length > 0) {
    var editor = ace.edit("editor");
    var sandboxedFrame = $("#sadboxed-eval")
    editor.getSession().setMode("ace/mode/javascript");

    var href = window.location.href.split("/");
    var id = href[href.length - 1];
    var cohort_id = $("#editor").data("cohort-id");

    $("button").prop('disabled', false);
    $(".loading").hide();
    $(".student-snippets").show();

    if ($(".student-editor").length > 0) {
      $.ajax({
        url: "/cohorts/" + cohort_id + "/student_snippets/" + id + ".json",
        success: function(data) {
          editor.setValue(data.body);
        }
      });

      $(".save_editor").on("click", function() {
        $(".saved-alert").show('fast');
        editor.focus();
        $.ajax({
          url: "/cohorts/" + cohort_id + "/student_snippets/" + id,
          type: "POST",
          data: { _method: "patch", student_snippet: { body: editor.getValue() }}
        });

        setTimeout(function() { $(".saved-alert").hide('fast')}, 2000)
      });
    };

    if ($(".instructor-editor").length > 0) {
      var studentSnippetCounter = 0;
      var snippet_id = $('.student-editor-link').first().data('snippet-id');
      $("a[data-snippet-id='" + snippet_id + "']").parent().addClass("active-snippet");
      $.ajax({
        url: "/cohorts/" + cohort_id + "/student_snippets/" + snippet_id + ".json",
        success: function(data) {
          editor.setValue(data.body);
        }
      });

      $(document).on("keydown", function(event) {
        if (event.metaKey && event.which === 74) {
          studentSnippetCounter++;
          var snippet_id = $('.student-editor-link').eq(studentSnippetCounter).data('snippet-id');
          $("td").removeClass("active-snippet");
          $("a[data-snippet-id='" + snippet_id + "']").parent().addClass("active-snippet");
          $.ajax({
            url: "/cohorts/" + cohort_id + "/student_snippets/" + snippet_id + ".json",
            success: function(data) {
              editor.setValue(data.body);
            }
          });
        } else if (event.metaKey && event.which === 75) {
          studentSnippetCounter--;
          var snippet_id = $('.student-editor-link').eq(studentSnippetCounter).data('snippet-id');
          $("td").removeClass("active-snippet");
          $("a[data-snippet-id='" + snippet_id + "']").parent().addClass("active-snippet");
          $.ajax({
            url: "/cohorts/" + cohort_id + "/student_snippets/" + snippet_id + ".json",
            success: function(data) {
              editor.setValue(data.body);
            }
          });
        }
      });
    }

    $(".student-editor-link").on("click", function(e) {
      var snippet_id = $(this).data('snippet-id');
      $("td").removeClass("active-snippet");
      $("a[data-snippet-id='" + snippet_id + "']").parent().addClass("active-snippet");
      $.ajax({
        url: "/cohorts/" + cohort_id + "/student_snippets/" + snippet_id + ".json",
        success: function(data) {
          editor.setValue(data.body);
        }
      });
      e.preventDefault();
    });

    $(".execute_editor").on("click", function() {
      $("#sandbox-result").text("");
      editor.focus();
      evaluate(sandboxedFrame);
    });

    $(document).on("keydown", function(event) {
      if (event.metaKey && event.which === 13) {
        $("#sandbox-result").text("");
        editor.focus();
        evaluate(sandboxedFrame);
      };
    });

    window.addEventListener('message', function (e) {
      if ((e.origin === "null" && e.source === sandboxedFrame.contentWindow)
          || (e.origin === (window.location.protocol + "//" + window.location.host))) {
        $("#sandbox-result").text(e.data);
      };
    });

    function evaluate(frame) {
      var code = editor.getValue();
      frame.get(0).contentWindow.postMessage(code, '*');
    };
  };
});
