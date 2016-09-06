# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  modal_window = $('.modal')
  modal_close = $('.modal-close, .modal-background')

  $('.show-item').click (event) ->
    event.preventDefault()
    modal_item = $(this).attr('item')
    $.ajax "/datatypes/#{modal_item}",
      type: 'GET'
      dataType: 'html'
      error: (jqXHR, errorThrown) ->
        alert(jqXHR.responseText)
      success: (data, textStatus, jqXHR) ->
        $('.modal-content').html(data)
        modal_window.addClass('is-active')

  modal_close.click ->
    modal_window.removeClass('is-active')

  $('#modal_back').click (event) ->
    event.preventDefault()
    modal.removeClass('is-active')
