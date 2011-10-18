if $('li#add_domain').length
  $('li#add_domain').prev().after('<%= escape_javascript(render(:partial => @domain)) %>').fadeIn()

