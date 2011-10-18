# replace the rails generated index of 0 with the correct one based on the number of meta_tags on the page
replaceCharWith = (str, oldChar, newChar) ->
  index = str.indexOf oldChar
  newStr = str.substring(0, index) + newChar + str.substring(index + 1)
 

if $('li#add_meta_tag').length
  $('li#add_meta_tag').before('<%= escape_javascript(render(:partial => @meta_tag)) %>').fadeIn()

  meta_tags = $('ul.meta_tags').find('li.meta_tag')

  if meta_tags.length > 0
    metaTagCount = meta_tags.length - 1
    lastList = meta_tags.last() 

    lastList.children().each ->
      if $(this).prop('tagName').toLowerCase() == "label"
        $(this).attr('for', replaceCharWith($(this).attr('for'), "0", metaTagCount))
      else if  $(this).prop('tagName').toLowerCase() ==  "input"
        $(this).attr('id', replaceCharWith($(this).attr('id'), "0", metaTagCount))
        $(this).attr('name', replaceCharWith($(this).attr('name'), "0", metaTagCount))

