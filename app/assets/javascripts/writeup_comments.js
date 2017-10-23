var WriteupComment = {
	initialize: function () {
		$(document).on('ajax:success', '[data-behavior=writeup-form]', function (e, response) {
			$(e.target).closest('.writeup-comments').replaceWith(response)
		})
	}
}
