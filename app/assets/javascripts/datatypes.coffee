# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

  modal_window = $('.modal')
  modal_header = $('.card-header-title')
  modal_oid = $('#metric_oid')
  modal_excl = $('#metric_excludes')
  modal_type = $('#metric_type')
  modal_table = $('#metric_table')
  modal_index = $('#metric_index')
  modal_close = $('.modal-close')

  $('.show-item').click (event) ->
    event.preventDefault()
    modal_item = $(this).attr('item')
    $.ajax "/datatypes/#{modal_item}.json",
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        alert(jqXHR.responseText)
      success: (data, textStatus, jqXHR) ->
        modal_header.text(data.name)
        modal_oid.text(data.oid)
        modal_type.text(data.metric_type)
        modal_table.text(data.table)
        if data.table is true
          modal_index.text(data.index_oid)
          modal_excl.text(data.excludes)
          modal_index.parent().show()
          modal_excl.parent().show()
        else
          modal_index.parent().hide()
          modal_excl.parent().hide()
        $('.item-edit').attr('href', "/datatypes/#{modal_item}/edit")
        $('.item-delete').attr('href', "/datatypes/#{modal_item}")
        modal_window.addClass('is-active')

  $('.modal-close').click ->
    $('.modal').removeClass('is-active')
