jQuery ->
  $(document).ready ->
    if $('body.pages').length
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false
      
      $('ul#sortable').sortable
        handle: 'em.sortable_list'
        axis: 'y'
        opacity: 0.6
