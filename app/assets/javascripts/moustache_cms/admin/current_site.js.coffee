$(document).ready ->
  if $('body.current_site').length
    $('span.delete_new_domain_name').live 'click', ->      
      $(this).parent().fadeToggle 'slow', 'linear', ->
        $(this).remove()
      false 

    $('span.delete_new_meta_tag').live 'click', ->      
      $(this).parent().fadeToggle 'slow', 'linear', ->
        $(this).remove()
      false 

    # meta_tag ajax spinner 
    $('#add_meta_tag a').bind 'ajax:before', ->
      $('#meta_tags_fieldset .spinner').removeClass('hidden')
    $('#add_meta_tag a').bind 'ajax:complete', ->
      $('#meta_tags_fieldset .spinner').addClass('hidden')

    # domains ajax spinner
    $('#add_domain a').bind 'ajax:before', ->
      $('#domains_fieldset .spinner').removeClass('hidden')
    $('#add_domain a').bind 'ajax:complete', ->
      $('#domains_fieldset .spinner').addClass('hidden')


