# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  host = $('#device_address')
  name = $('#device_devname')
  cont = $('#device_contact')
  city = $('#device_city')
  getinfo = $('#getinfo')

  getinfo.click ->
    getinfo.removeClass('is-loading is-warning is-danger is-success')
    getinfo.addClass('is-warning is-loading')
    host.addClass('is-warning')
    $('#snmp_error').remove()
    $.ajax '/snmpquerier/getinfo',
      type: 'POST'
      dataType: 'json'
      data: "host": host.val()
      error: (jqXHR, textStatus, errorThrown) ->
        getinfo.removeClass('is-loading is-warning is-danger is-success')
        getinfo.addClass('is-danger')
        host.removeClass('is-danger is-warning')
        host.addClass('is-danger')
        host.after("<span class=\"help is-danger\" id=\"snmp_error\">#{jqXHR.responseText}</span>")
      success: (data, textStatus, jqXHR) ->
        getinfo.removeClass('is-loading is-warning is-danger is-success')
        getinfo.addClass('is-success')
        host.removeClass('is-danger is-warning')
        host.addClass('is-success')
        name.val(data.name)
        cont.val(data.contact)
        city.val(data.location.split(',')[0])
