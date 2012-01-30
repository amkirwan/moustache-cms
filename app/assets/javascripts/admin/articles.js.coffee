jQuery -> 
  $(document).ready ->
    if $('body.articles').length

      /* hide initial form elements */
      $('#advanced_fields legend').siblings().first().hide()
      $('#advanced_fields legend').find('span').removeClass('rotate')

      $('#meta_tags_fields legend').siblings().first().hide()
      $('#meta_tags_fields legend').find('span').removeClass('rotate')

      /* meta_tag remove new meta tag*/
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

