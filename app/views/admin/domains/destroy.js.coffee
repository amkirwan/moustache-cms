domainNameId = (str) ->
  str = str.replace(/\./g, '_')
  str.toLowerCase()

if $('div#flash_notice_wrapper')
  $('div#flash_notice_wrapper').fadeToggle 'slow', 'linear', ->
    $(this).remove()

$('#site_domain_name_' + domainNameId("<%= @domain_name %>")).fadeToggle 'slow', 'linear', ->
  $(this).next().remove()
  $(this).remove()
