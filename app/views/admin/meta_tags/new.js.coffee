if $('li#add_meta_tag').length
  $('li#add_meta_tag').prev().after('<%= render(:partial => @meta_tag) %>').fadeIn()
