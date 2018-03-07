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
  table = $('#datatype_table')

  # Set initial state for table-related fields:
  table_form(table)
  # And do the same every time user changes the "Table" checkbox:
  table.change ->
    table_form($(this))

$(document).on('turbolinks:load', ready)
