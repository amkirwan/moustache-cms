pageId = ->
  '<%= @page.title.parameterize + '_' + @page.id.to_s %>'

if $('div#content')
  $('div#content').prepend('<%= escape_javascript(render :partial => "shared/flash_notice") %>')

$("div#flash_notice_wrapper").delay(1000).fadeToggle "slow", "linear", ->
  $(this).remove()

$('li#' + pageId()).fadeToggle "slow", "linear", ->
  $(this).remove()

