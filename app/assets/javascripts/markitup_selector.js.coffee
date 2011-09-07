jQuery ->
  $(document).ready -> 

    #START:pageFilter
    pagePartSettings = (filterText, pagePart) ->
      if filterText == "markdown"
        pagePart.markItUp(markdownSettings)
      else if filterText == "textile"
        pagePart.markItUp(textileSettings)
      else if filterText == "html"
        pagePart.markItUp(htmlSettings)
    #END:pageFilter
    
    if $("body.pages").length
      $(".page_part_filter option:selected").each ->
        pagePartSettings $(this).text(), $('textarea.page_part_contents')
        
      $('.page_part_filter').change ->
        $(".page_part_filter option:selected").each ->
          page_part = $("textarea.page_part_contents")
          page_part.markItUpRemove()
          pagePartSettings $(this).text(), page_part

