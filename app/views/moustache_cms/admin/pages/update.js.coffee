if sessionStorage? && sessionStorage.pagesState?
  $('#content_inner_wrapper').html getLocalStore('pagesState')
  if $('#<%= page_id_was %>').length > 0
    console.log 'Hello, World'
    $('#<%= page_id_was %>').replaceWith '<%= escape_javascript(render :partial => "page", :object => @page) %>'
    setSessionStore 'pagesState', $('#content_inner_wrapper').html()
