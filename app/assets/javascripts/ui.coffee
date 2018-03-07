# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready= ->
  modal_window =  $('.modal')
  modal_close =   $('.modal-close, .modal-background')
  modal_back =    $('#modal_back')

  $('.burger').click ->
    $('.navbar-menu').toggleClass('is-active')
    $('.burger').toggleClass('is-active')

  $('#delete_notification').click ->
    $(this).parent().remove()

  $('.show-item').click (event) ->
    event.preventDefault()
    modal_item = $(this).attr('item')
    $.ajax "/#{modal_item}",
      type: 'GET'
      dataType: 'html'
      error: (jqXHR) ->
        alert(jqXHR.responseText)
      success: (data) ->
        $('.modal-content').html(data)
        modal_window.addClass('is-active')

  modal_close.click ->
    modal_window.removeClass('is-active')

  modal_back.click (event) ->
    event.preventDefault()
    modal_window.removeClass('is-active')


$(document).on('turbolinks:load', ready)
