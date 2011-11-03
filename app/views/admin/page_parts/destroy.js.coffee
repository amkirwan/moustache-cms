pagePartId = '#page_part_' + '<%= @page_part.id %>'
pagePartNav = '#' + '<%= @page_part.id %>' + '_nav'

if $(pagePartId).length
  $(pagePartId).fadeToggle 'slow', 'linear', ->
    $(this).next().remove()
    $(this).remove()
  
  $(pagePartNav).fadeToggle 'slow', 'linear', ->
    $(this).next().remove()
    $(this).remove()
    $('#page_parts_nav .tab').last().addClass('page_part_selected').addClass('selected')
    $('ul.page_part').last().removeClass('hidden')

