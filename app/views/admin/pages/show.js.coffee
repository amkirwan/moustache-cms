if $('li#<%= page_id(@page) %>')
  pageList = $('li#<%= page_id(@page) %>')
  pageFoldArrow = pageList.children().first()
  pageList.append('<%= escape_javascript(render_pages @page.children) %>')
  pageList.addClass 'child_pages'
  pageFoldArrow.addClass 'page_fold_arrow_ccw'
