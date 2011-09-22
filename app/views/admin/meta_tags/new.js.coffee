# replace the rails generated index of 0 with the correct one based on the number of meta_tags on the page
replaceCharWith = (str, oldChar, newChar) ->
  index = str.indexOf oldChar
  newStr = str.substring(0, index) + newChar + str.substring(index + 1)
 

if $('li#add_meta_tag').length
  $('li#add_meta_tag').prev().after('<%= escape_javascript(render(:partial => @meta_tag)) %>').fadeIn()

  metaTagCount = $('div#page_meta_tags').find('li.meta_tag').length - 1
  lastList = $('div#page_meta_tags').find('li.meta_tag').last() 

  lastList.children().each ->
    if $(this).prop('tagName').toLowerCase() == "label"
      $(this).attr('for', replaceCharWith($(this).attr('for'), "0", metaTagCount))
    else if  $(this).prop('tagName').toLowerCase() ==  "input"
      $(this).attr('id', replaceCharWith($(this).attr('id'), "0", metaTagCount))
      $(this).attr('name', replaceCharWith($(this).attr('name'), "0", metaTagCount))
  
  lastList.find('a.delete_new_meta_tag').bind 'click', ->
    $(this).parent().fadeToggle 'slow', 'linear', -> 
      $(this).remove()
    return false
