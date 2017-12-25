# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready= ->
  $('.burger').click ->
    $('.navbar-menu').toggleClass('is-active')
    $('.burger').toggleClass('is-active')

  $('#delete_notification').click ->
    $(this).parent().remove()

$(document).on('turbolinks:load', ready)
