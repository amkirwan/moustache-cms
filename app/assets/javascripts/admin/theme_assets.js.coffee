jQuery ->
  $(document).ready ->
    if $('body.theme_assets').length
      $('span.delete_new_tag_attr').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false
