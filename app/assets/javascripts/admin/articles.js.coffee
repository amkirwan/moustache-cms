$(document).ready ->
  if $('body.articles').length

    # hide initial form elements 
    $('#advanced_fields legend').siblings().first().hide()
    $('#advanced_fields legend').find('span').removeClass('rotate')
    
    $('#author_fields legend').siblings().first().hide()
    $('#author_fields legend').find('span').removeClass('rotate')

    $('#meta_tags_fields legend').siblings().first().hide()
    $('#meta_tags_fields legend').find('span').removeClass('rotate')

    # meta_tag remove new meta tag
    $('span.delete_new_meta_tag').on 'click', ->      
      $(this).parent().fadeToggle 'slow', 'linear', ->
        $(this).remove()
      false
    $('.preview').click (e) ->
          e.preventDefault()
          $.each MoustacheEditor.editors, (index, editor) ->
            editor.updateTextarea()
          form = $('form.article')
          action = form.attr('action').split('/')
          article_collection_id = action[3]
          article_id = action[action.length - 1]
          url = '/admin/article_collections/' + article_collection_id + '/articles/' + article_id + '/preview'
          $.post url, form.serialize(), -> 
