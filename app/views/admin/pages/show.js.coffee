if $('li#<%= page_id(@page) %>')
  pageList = $('li#<%= page_id(@page) %>')
  pageFoldArrow = pageList.children().first()
  if pageList.hasClass('child_pages') && pageFoldArrow.hasClass('page_fold_arrow_ccw')
    pageList.children('.pages').first().slideUp 'slow', ->
      pageFoldArrow.removeClass 'page_fold_arrow_ccw'
  else if pageList.hasClass('child_pages')
    pageList.children('.pages').first().slideDown 'slow', ->
      pageFoldArrow.addClass 'page_fold_arrow_ccw'
  else
    pageList.append('<%= escape_javascript(render_pages @page.children) %>')
    pageList.addClass 'child_pages'
    pageFoldArrow.addClass 'page_fold_arrow_ccw'

