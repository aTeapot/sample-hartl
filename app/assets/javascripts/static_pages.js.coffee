# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'focus', '#micropost_content', ->
  updateLeft()
  $('#characters-left').show()

$(document).on 'keyup', '#micropost_content', ->
  updateLeft()

updateLeft = ->
  left = 140 - $('#micropost_content').val().length
  $('#characters-left').text("#{left} characters left")
