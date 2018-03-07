# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready= ->
  host =          $('#device_address')
  community =     $('#device_snmp_community')
  name =          $('#device_devname')
  contact =       $('#device_contact')
  city =          $('#device_city')
  getinfo =       $('#getinfo')

  getinfo.click (event)->
    getinfo.removeClass('is-loading is-warning is-danger is-success')
    getinfo.addClass('is-warning is-loading')
    host.addClass('is-warning')
    $('#snmp_error').remove()
    event.preventDefault()
    $.ajax '/snmpquerier/getinfo',
      type: 'POST'
      dataType: 'json'
      data: {'host': host.val(), 'community': community.val()}
      error: (jqXHR) ->
        getinfo.removeClass('is-loading is-warning is-danger is-success')
        getinfo.addClass('is-danger')
        host.removeClass('is-danger is-warning')
        host.addClass('is-danger')
        host.after("<span class=\"help is-danger\" id=\"snmp_error\">" + jqXHR.responseText + "</span>")
      success: (response_data) ->
        getinfo.removeClass('is-loading is-warning is-danger is-success')
        getinfo.addClass('is-success')
        host.removeClass('is-danger is-warning')
        host.addClass('is-success')
        name.val(response_data.name)
        contact.val(response_data.contact)
        city.val(response_data.location.split(',')[0])

$(document).on('turbolinks:load', ready)
