# don't submit blank form
$(document).on 'click', '.search .btn', ->
  if /^\s*$/.test($('#search').val())
    $('#error').show()
    false
