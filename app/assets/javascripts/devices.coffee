# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  host = $('#device_address')
  name = $('#device_devname')
  cont = $('#device_contact')
  getinfo = $('#getinfo')

  getinfo.click ->
    $.ajax '/snmpquerier/getinfo',
      host: host.val()
      type: 'POST'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        alert("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        name.val(data.devname)
        cont.val(data.contact)
