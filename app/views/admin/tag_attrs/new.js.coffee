replaceCharWith = (str, oldChar, newChar) ->
  index = str.indexOf oldChar
  newStr = str.substring(0, index) + newChar + str.substring(index + 1)

if $('li#add_tag_attr').length
  $('li#add_tag_attr').prev().after('<%= escape_javascript(render(:partial => @tag_attr)) %>').fadeIn()

  tag_attrs = $('ul#page_tag_attrs').find('li.tag_attr')
  tagAttrCount = tag_attrs.length - 1
  lastList = tag_attrs.last() 

  lastList.children().each ->
    if $(this).prop('tagName').toLowerCase() == "label"
      $(this).attr('for', replaceCharWith($(this).attr('for'), "0", tagAttrCount))
    else if  $(this).prop('tagName').toLowerCase() ==  "input"
      $(this).attr('id', replaceCharWith($(this).attr('id'), "0", tagAttrCount))
      $(this).attr('name', replaceCharWith($(this).attr('name'), "0", tagAttrCount))

