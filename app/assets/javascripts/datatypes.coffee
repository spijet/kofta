# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
table_form = (table) ->
  index_oid = $('#datatype_index_oid')
  exclude = $('#datatype_excludes')
  table_val = table.prop('checked')
  console.log table_val
  if !table_val
    index_oid.val('')
    exclude.val('')
  index_oid.prop('disabled', !table_val)
  exclude.prop('disabled', !table_val)

ready= ->
  modal_window =  $('.modal')
  modal_close =   $('.modal-close, .modal-background')
  modal_back =    $('#modal_back')
  table = $('#datatype_table')

  # Set initial state for table-related fields:
  table_form(table)
  # And do the same every time user changes the "Table" checkbox:
  table.change ->
    table_form($(this))

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

$(document).on('turbolinks:load', ready)
