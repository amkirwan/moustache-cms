# replace the rails generated index of 0 with the correct one based on the number of custom_fields on the page
replaceCharWith = (str, oldChar, newChar) ->
  index = str.indexOf oldChar
  newStr = str.substring(0, index) + newChar + str.substring(index + 1)
 

if $('li#add_custom_field').length
  $('li#add_custom_field').before('<%= escape_javascript(render(:partial => @custom_field)) %>').fadeIn()

  custom_fields = $('ol.custom_fields').find('li.custom_field')

  if custom_fields.length > 0
    customFieldCount = custom_fields.length - 1
    lastList = custom_fields.last() 

    lastList.children().each ->
      if $(this).prop('tagName').toLowerCase() == "label"
        $(this).attr('for', replaceCharWith($(this).attr('for'), "0", customFieldCount))
      else if  $(this).prop('tagName').toLowerCase() ==  "input"
        $(this).attr('id', replaceCharWith($(this).attr('id'), "0", customFieldCount))
        $(this).attr('name', replaceCharWith($(this).attr('name'), "0", customFieldCount))


