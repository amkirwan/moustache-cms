jQuery ->
  $(document).ready ->
    if $('body.pages').length
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      /* sort index page pages */
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

      /* hide initial form elements */
      $('.site_prop #advanced_options').css 'display', 'none'
      $('.site_prop #advanced_options').prev().find('span').removeClass('rotate')

      $('.site_prop #page_meta_tags').css 'display', 'none'
      $('.site_prop #page_meta_tags').prev().find('span').removeClass('rotate')

      /* meta_tag ajax spinner */
      $('#add_meta_tag a').bind 'ajax:before', ->
        $('#meta_tags_fieldset .spinner').removeClass('hidden')
      $('#add_meta_tag a').bind 'ajax:complete', ->
        $('#meta_tags_fieldset .spinner').addClass('hidden')

      /* new page ajax add meta_tag */
      if $('p#meta_tag_message').length
        $('#meta_tag_message').remove()
        $('#add_meta_tag').append('<span class="fake_link">Add Meta Tag</span>')
        $('#add_meta_tag .fake_link').click ->
          $.get '/admin/pages/new_meta_tag', ->

      /* page parts ajax spinner */
      $('ul#page_parts_nav a').bind 'ajax:beforeSend', ->
        $('.page_parts div.spinner_wrapper .spinner').removeClass('hidden')
      $('ul#page_parts_nav a').bind 'ajax:success', ->
        $('.page_parts div.spinner_wrapper .spinner').addClass('hidden')


      /* change page part nav name */
      $('li.page_part_name input').live 'change', ->
        pp_id = $(this).parent().parent().next().attr 'value'
        page_part_nav_link = $('ul#page_parts_nav #' + pp_id + '_nav').find('a')
        old_val = page_part_nav_link.html()

        /* if new value isn't blank change it if it is set it back to the old value */
        if $(this).attr('value').trim()
          page_part_nav_link.html $(this).attr('value')
        else
          page_part_nav_link.html old_val
          $(this).attr 'value', old_val


