if $('#view').length > 0
  $('#view').attr 'value', '<%= @selected_page_part.id %>'


if $('ol#page_parts_nav').length > 0
  $('ol#page_parts_nav li.selected').removeClass('selected')
  $('ol#page_parts_nav li#<%= @selected_page_part.id %>_nav').addClass('selected')
  $('.page_parts .page_part').addClass('hidden')
  $('.page_parts .page_part').removeClass('page_part_selected')
  $('.page_parts #page_part_<%= @selected_page_part.id %>').removeClass('hidden').addClass('page_part_selected')

  $('.delete_page_part').html('<%= delete_page_part %>')

