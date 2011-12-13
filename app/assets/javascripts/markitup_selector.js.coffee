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
      filters = []
      $('.page_parts select').each -> 
        filters.push $(this)
      
      $('.page_parts textarea').each (index) ->
        contentSettings filters[index].val(), $(this) 

      $('.page_part_filter').live 'change', ->
        pagePartContent = $(this).parent().next().find('textarea')
        pagePartContent.markItUpRemove()
        contentSettings $(this).val(), pagePartContent
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
    else if $('body.articles').length
      $('#article_filter_name option:selected').each ->
        contentSettings $(this).text(), $('textarea#article_content')  

      $('#article_filter_name').change ->
        $('#article_filter_name option:selected').each ->
          articleContent = $('textarea.article_content')
          articleContent.markItUpRemove()
          contentSettings $(this).text(), articleContent
