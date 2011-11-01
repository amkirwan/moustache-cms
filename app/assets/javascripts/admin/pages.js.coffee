jQuery ->
  $(document).ready ->
    if $('body.pages').length
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      /* hide initial form elements */
      $('.site_prop #advanced_options').css 'display', 'none'
      $('.site_prop #advanced_options').prev().find('span').removeClass('rotate')

      $('.site_prop #page_meta_tags').css 'display', 'none'
      $('.site_prop #page_meta_tags').prev().find('span').removeClass('rotate')

      /* new page ajax add meta_tag */
      if $('p#meta_tag_message').length
        $('#meta_tag_message').remove()
        $('#add_meta_tag').append('<span class="fake_link">Add Meta Tag</span>')
        $('#add_meta_tag .fake_link').click ->
          $.get '/admin/pages/new_meta_tag', ->
            console.log 'success'
            

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
