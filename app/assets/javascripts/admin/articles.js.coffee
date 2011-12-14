jQuery -> 
  $(document).ready ->
    if $('body.articles').length
      /* meta_tag remove new meta tag*/
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      /* meta_tag ajax spinner */
      $('#add_meta_tag a').bind 'ajax:before', ->
        $('#meta_tags_fieldset .spinner').removeClass('hidden')
      $('#add_meta_tag a').bind 'ajax:complete', ->
        $('#meta_tags_fieldset .spinner').addClass('hidden')

      /* new article ajax add meta_tag */
      if $('p#meta_tag_message').length
        $('#meta_tag_message').remove()
        $('#add_meta_tag').append('<span class="fake_link">Add Meta Tag</span>')
        $('#add_meta_tag .fake_link').click ->
          $.get '/admin/articles/new_meta_tag', ->
