root = window
child_pages = '<%= escape_javascript(render_pages @page.children) %>'
if $('li#<%= page_id(@page) %>') and child_pages?.length
  pageList = $('li#<%= page_id(@page) %>')
  pageFoldArrow = pageList.children().first()
  pageList.append child_pages
  pageList.addClass 'child_pages'
  pageFoldArrow.addClass 'page_fold_arrow_ccw'
  root.sortablePageList pageList.children('ol.sortable')
