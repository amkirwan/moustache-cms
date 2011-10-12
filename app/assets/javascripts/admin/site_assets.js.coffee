jQuery ->
  setClear = ->
    container = $('.show_asset_collection')
    containerWidth = container.width()
    currentWidth = 0

    container.children().each ->
      $(this).css 'clear', ''

    container.children().each ->
      currentWidth += $(this).outerWidth true
      if currentWidth >= containerWidth
        $(this).css 'clear', 'left'
        currentWidth = $(this).outerWidth true

  $(document).ready ->
    if $('body.site_assets').length
      setClear()
      $(window).resize ->
        setClear()
     
  
