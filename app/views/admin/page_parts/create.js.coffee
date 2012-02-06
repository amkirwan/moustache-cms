$('.page_parts .form_fields').last().after('<%= escape_javascript(render :partial => "page_part", :locals => { :index => (@page.page_parts.size - 1) } ) %>')

/* hide current showing page part */
$('ol.page_part_selected').removeClass('page_part_selected').hide()

/* show new page path */
$('ol#page_part_<%= @page_part.id %>').addClass('page_part_selected').show()

/* remove css for seleted nav */
$('#page_parts_nav .selected').removeClass('selected')

/* add to page part nav and make it the selected tab*/
$('#page_parts_nav .tab').last().after('<%= escape_javascript(render :partial => "page_part_nav") %>')

$('.delete_page_part').html('<%= delete_page_part %>')

if $('#view').length > 0
  $('#view').attr 'value', '<%= @page_part.id %>'

editor = new HandlebarEditor '<%= @page_part.id %>_content'
editor.contentSettings $('.page_parts select').last().val()
editor.hideUpdateTextarea()
HandlebarEditor.editors.push editor
