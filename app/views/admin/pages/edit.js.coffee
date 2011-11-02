if $('ul#page_parts_nav').length > 0
  $('ul#page_parts_nav li.selected').removeClass('selected')
  $('ul#page_parts_nav li#<%= @selected_page_part.name %>_nav').addClass('selected')
  $('fieldset .page_parts .page_part').addClass('hidden')
  $('fieldset .page_parts #page_part_<%= @selected_page_part.name %>').removeClass('hidden')


  
