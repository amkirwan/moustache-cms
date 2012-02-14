if localStorage? && localStorage.pagesState?
  $('#content_inner_wrapper').html getLocalStore('pagesState')
  if $('#<%= page_id_was %>').length > 0
    console.log 'Hello, World'
    $('#<%= page_id_was %>').replaceWith '<%= escape_javascript(render :partial => "page", :object => @page) %>'
    setLocalStore 'pagesState', $('#content_inner_wrapper').html()

#history.pushState 'pages', '', '/admin/pages'
