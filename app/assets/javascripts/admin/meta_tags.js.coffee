jQuery ->
  $(document).ready ->

      /* meta_tag remove new meta tag*/
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      /* new page ajax add meta_tag */
      if $('p#meta_tag_message').length
        $('#meta_tag_message').remove()
        $('#add_meta_tag').append('<span class="fake_link">Add Meta Tag</span>')
        $('#add_meta_tag .fake_link').click ->
          $('#meta_tags_fieldset .spinner').removeClass('hidden')
          $.get '/admin/pages/new_meta_tag', ->
            $('#meta_tags_fieldset .spinner').addClass('hidden')

      /* meta_tag ajax spinner */
      $('#add_meta_tag a').bind 'ajax:before', ->
        $('#meta_tags_fieldset .spinner').removeClass('hidden')
      $('#add_meta_tag a').bind 'ajax:complete', ->
        $('#meta_tags_fieldset .spinner').addClass('hidden')
