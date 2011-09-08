jQuery ->
  $(document).ready -> 

    #START:pageFilter
    contentSettings = (filterText, contentArea) ->
      if filterText == "markdown"
        contentArea.markItUp(markdownSettings)
      else if filterText == "textile"
        contentArea.markItUp(textileSettings)
      else if filterText == "html"
        contentArea.markItUp(htmlSettings)
      else if filterText == "haml"
        contentArea.markItUp(defaultSettings)
      else if filterText == "css"
        $('textarea.code').markItUp(cssSettings)
    #END:pageFilter
    
    if $('body.pages').length
      $('.page_part_filter option:selected').each ->
        contentSettings $(this).text(), $('textarea.page_part_contents')
        
      $('.page_part_filter').change ->
        $('.page_part_filter option:selected').each ->
          pagePartContent = $("textarea.page_part_contents")
          pagePartContent.markItUpRemove()
          contentSettings $(this).text(), pagePartContent
    else if $('body.layouts').length
      contentSettings "html", $('textarea.code')
    else if $('body.snippets').length
      $('#snippet_filter_name option:selected').each ->
        contentSettings $(this).text(), $('textarea#snippet_content')  
      $('#snippet_filter_name').change ->
        $('#snippet_filter_name option:selected').each ->
          snippetContent = $('textarea#snippet_content')
          snippetContent.markItUpRemove()
          contentSettings $(this).text(), snippetContent
    else if $('body.theme_assets').length
      contentSettings "css", $('textarea.code')
