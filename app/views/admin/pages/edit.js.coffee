if $('ul.page_parts').length > 0
  $('ul.page_parts').html('<%= escape_javascript(render(:partial => "admin/pages/page_parts")) %>')
