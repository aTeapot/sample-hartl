$(document).ready ->
  $(document).on 'focus', '#micropost_content', ->
    updateLeft()
    $('#characters-left').show()
  
  $(document).on 'keyup', '#micropost_content', ->
    updateLeft()
  
updateLeft = ->
  left = 140 - $('#micropost_content').val().length
  $('#characters-left').text("#{left} characters left")
