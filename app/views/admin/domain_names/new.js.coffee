if $('li#add_domain').length
  $('li#add_domain').before('<%= escape_javascript(render(:partial => 'admin/domains/domain')) %>').fadeIn()

