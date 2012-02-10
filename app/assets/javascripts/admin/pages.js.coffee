$(document).ready ->
  if $('body.pages').length

    /* sort index page pages */
    $('ol.sortable').sortable
      handle: 'em.sortable_list'
      axis: 'y'
      opacity: 0.6
      update: (event, ui) ->
        params = $(this).sortable 'serialize'
          'key': 'children[]' 
        params += '&_method=put'
        params += '&' + $('meta[name=csrf-param]').attr('content') + '=' + $('meta[name=csrf-token]').attr('content')

        $.post $(this).attr('data-url'), params

    /* hide initial form elements */
    $('legend').each ->
      $(this).siblings().first().hide()      
    $('legend').each ->
      $(this).find('span').addClass('rotate-ccw')

    $('fieldset.page_parts legend').siblings().first().show()
    $('fieldset.page_parts legend').find('span').removeClass('rotate-ccw')

    /* page parts ajax spinner */
    $('ol#page_parts_nav a').live 'ajax:beforeSend', ->
      $('.page_parts div.spinner_wrapper .spinner').removeClass 'hidden'
    $('ol#page_parts_nav a').live 'ajax:success', ->
      $('.page_parts div.spinner_wrapper .spinner').addClass 'hidden'

    $('.page_fold_arrow').live 'ajax:beforeSend', ->
      contentTop = $('#content').offset().top
      pageFoldTop = $(this).offset().top
      $('.spinner').css('top', pageFoldTop - contentTop - 72)
      $('.spinner').removeClass 'hidden'
    $('.page_fold_arrow').live 'ajax:success', ->
      $('.spinner').addClass 'hidden'
      $('.spinner').css('top', 0)

    /* change page part nav name */
    $('li.page_part_name input').live 'change', ->
      pp_id = $(this).parent().siblings().last().children().first().attr 'value'
      page_part_nav_link = $('ol#page_parts_nav #' + pp_id + '_nav').find('a')
      old_val = page_part_nav_link.html()

      /* if new value isn't blank change it if it is set it back to the old value */
      if $(this).attr('value').trim()
        page_part_nav_link.html $(this).attr('value')
      else
        page_part_nav_link.html old_val
        $(this).attr 'value', old_val


