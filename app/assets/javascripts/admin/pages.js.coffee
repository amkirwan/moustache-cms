jQuery ->
  $(document).ready ->
    if $('body.pages').length
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      $('.site_prop #advanced_options').css 'display', 'none'
      $('.site_prop #advanced_options').prev().find('span').removeClass('rotate')

      $('.site_prop #page_meta_tags').css 'display', 'none'
      $('.site_prop #page_meta_tags').prev().find('span').removeClass('rotate')

      $('ul.sortable').sortable
        handle: 'em.sortable_list'
        axis: 'y'
        opacity: 0.6
        update: (event, ui) ->
          params = $(this).sortable 'serialize'
            'key': 'children[]' 
          params += '&_method=put'
          params += '&' + $('meta[name=csrf-param]').attr('content') + '=' + $('meta[name=csrf-token]').attr('content')

          $.post $(this).attr('data_url'), params
