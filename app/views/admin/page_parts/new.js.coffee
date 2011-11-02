$('.page_parts .form_fields').last().next().after('<%= escape_javascript(render :partial => "page_part", :locals => { :index => (@page.page_parts.size - 1) } ) %>')
