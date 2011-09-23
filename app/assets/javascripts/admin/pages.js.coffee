jQuery ->
  $(document).ready ->
    if $('body.pages').length
      $('span.delete_new_meta_tag').live 'click', ->      
        $(this).parent().fadeToggle 'slow', 'linear', ->
          $(this).remove()
        false

      $(".foldable fieldset legend").mouseup ->
          legend = $(this)
          legend.next("ul.form_fields").slideToggle "slow", ->
            arrow = legend.children().first()
            if arrow.hasClass("rotate")
              arrow.removeClass("rotate")
            else
              arrow.addClass("rotate")     
