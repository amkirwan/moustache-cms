if $('div#content')
  $('div#content').prepend('<%= escape_javascript(render :partial => "shared/flash_notice") %>')

$("div#flash_notice_wrapper").delay(1000).fadeToggle "slow", "linear", ->
  $(this).remove()

$('#<%= page_id @page %>').fadeToggle "slow", "linear", ->
  parent = $(@).parent()
  $(@).remove()
  if parent.children().size() == 0
    pageFoldArrow = parent.siblings('.page_fold_arrow_ccw')
    pageFoldArrow.fadeOut 'slow', ->
      $(@).remove()
    parent.remove()
