jQuery ->
  $(document).ready ->
    if $('body.current_site').length
      $('span.delete_new_domain_name').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false 
