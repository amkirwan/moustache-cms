pageId = ->
  '<%= @page.title.parameterize + '_' + @page.id.to_s %>'

if $('div#content')
  $('div#content').prepend('<%= escape_javascript(render :partial => "shared/flash_notice") %>')

$("div#flash_notice_wrapper").delay(1000).fadeToggle "slow", "linear", ->
  $(this).remove()

$('li#' + pageId()).fadeToggle "slow", "linear", ->
  parent = $(@).parent()
  $(@).remove()
  if parent.children().size() == 0
    pageFoldArrow = parent.siblings('.page_fold_arrow_ccw')
    pageFoldArrow.fadeOut 'slow', ->
      $(@).remove()
    parent.remove()
