$('.page_parts .form_fields').last().next().after('<%= escape_javascript(render :partial => "page_part", :locals => { :index => (@page.page_parts.size - 1) } ) %>')

/* hide current showing page part */
$('ol.page_part_selected').removeClass('page_part_selected').addClass('hidden')

/* show new page path */
$('ol#page_part_<%= @page_part.id %>').removeClass('hidden').addClass('page_part_selected')

/* remove css for seleted nav */
$('#page_parts_nav .selected').removeClass('selected')

/* add to page part nav and make it the selected tab*/
$('#page_parts_nav .tab').last().after('<%= escape_javascript(render :partial => "page_part_nav") %>')

/* add markitup form */
$('ol#page_part_<%= @page_part.id %> textarea').markItUp(markdownSettings)

$('.delete_page_part').html('<%= delete_page_part %>')
