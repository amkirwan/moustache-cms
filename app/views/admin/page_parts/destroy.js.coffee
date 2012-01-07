pagePartId = '#page_part_' + '<%= @page_part.id %>'
pagePartNavId = '#' + '<%= @page_part.id %>' + '_nav'

if $(pagePartId).length
  $(pagePartId).fadeToggle 'slow', 'linear', ->
    $(this).next().remove()
    $(this).remove()
  
  $(pagePartNavId).fadeToggle 'slow', 'linear', ->
    $(this).remove()
    $('#page_parts_nav .tab').last().addClass('selected')
    $('#page_parts_wrapper ol').last().removeClass('page_part_selected hidden')
    $('.delete_page_part').html('<%= delete_page_part %>')

