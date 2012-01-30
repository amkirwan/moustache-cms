jQuery ->
  $(document).ready ->

      /* custom_field remove new custom field */
      $('span.delete_new_custom_field').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      /* new page ajax add custom_field */
      if $('p#custom_field_message').length
        $('#custom_field_message').remove()
        $('#add_custom_field').append('<span class="fake_link">Add Custom Field</span>')
        $('#add_custom_field').click ->
          $('#custom_fields_fieldset .spinner').removeClass('hidden')
          $.get '/admin/pages/new_custom_field', ->
            $('#custom_fields_fieldset .spinner').addClass('hidden')

      /* custom_field ajax spinner */
      $('#add_custom_field a').bind 'ajax:before', ->
        $('#custom_fields_fieldset .spinner').removeClass('hidden')
      $('#add_custom_field a').bind 'ajax:complete', ->
        $('#custom_fields_fieldset .spinner').addClass('hidden')

