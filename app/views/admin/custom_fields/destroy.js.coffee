metaTagId = (str) ->
  str = str.replace(/\./g, '_')
  str.toLowerCase()

if $('div#flash_notice_wrapper')
  $('div#flash_notice_wrapper').fadeToggle 'slow', 'linear', ->
    $(this).remove()

$('#custom_field_' + metaTagId("<%= @custom_field.name %>")).fadeToggle 'slow', 'linear', ->
  $(this).next().remove()
  $(this).remove()

