if $('div#flash_notice_wrapper')
  $('div#flash_notice_wrapper').fadeToggle 'slow', 'linear', ->
    $(this).remove()

$('#meta_tag_<%= @meta_tag.id %>').fadeToggle 'slow', 'linear', ->
  $(this).next().remove()
  $(this).remove()
