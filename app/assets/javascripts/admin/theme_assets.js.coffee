jQuery ->
  $(document).ready ->
    if $('body.theme_assets').length
      $(".foldable fieldset legend").mouseup ->
          legend = $(this)
          legend.next("ul.form_fields").slideToggle "slow", ->
            arrow = legend.children().first()
            if arrow.hasClass("rotate")
              arrow.removeClass("rotate")
            else
              arrow.addClass("rotate")     
