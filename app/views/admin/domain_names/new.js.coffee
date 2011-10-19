if $('li#add_domain').length
  $('li#add_domain').before('<%= escape_javascript(render(:partial => 'admin/domain_names/domain')) %>').fadeIn()

