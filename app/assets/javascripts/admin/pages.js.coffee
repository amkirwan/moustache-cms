$(document).ready ->
  if $('body.pages').length

    root = global ? window
    # sort index page pages
    root.sortablePageList = (pageList) ->
      pageList.sortable
        handle: 'em.sortable_list'
        axis: 'y'
        opacity: 0.6
        update: (event, ui) ->
          params = $(this).sortable 'serialize'
            'key': 'children[]' 
          params += '&_method=put'
          params += '&' + $('meta[name=csrf-param]').attr('content') + '=' + $('meta[name=csrf-token]').attr('content')
          $.post $(this).attr('data-url'), params

    # hide initial form elements 
    $('legend').each ->
      $(this).siblings().first().hide()      
    $('legend').each ->
      $(this).find('span').addClass('rotate-ccw')
    
    root.setLocalStore = (key, val) ->
      localStorage.setItem key, JSON.stringify(val)

    root.getLocalStore = (store) ->
      JSON.parse localStorage.getItem(store)

    ###
    Recursively call pageListGet with page_ids from localStorage and call them via ajax
    If the page page_parent_id cookie then highlight the text
    ###
    pageListGet = (page_ids) ->
      $('.spinner').removeClass 'hidden'
      if page_ids.length > 0
        page_id = page_ids.shift()
        $.ajax '/admin/pages/' + page_id + '.js', 
          success: (data) ->
            pageListGet page_ids
          complete: ->
            if page_id == $.cookies.get('page_parent_id') 
              page_id = $.cookies.get('page_created_updated_id')
              el = $("li").find("[data-page_id='" + page_id + "']")
              el.find('.edit_page').animate({ color: '#e2e288' }, 1000).delay(1500).animate({ color: '#d54e0e' }, 3000)
              el.find('.page_info span').stop().animate({ color: '#e2e288' }, 1000).delay(1500).animate({ color: '#9C9C9C' }, 3000)
              $.cookies.del('page_created_updated_id')
              $.cookies.del('page_parent_id')
          error: ->
            pageListGet page_ids
      else
        $('.spinner').addClass 'hidden'

    ###
    If the page_list and the localStorage pagesState exists then call call the pageListGet with the
    stored page_ids
    ###
    if $('#pages_list').length && localStorage?.pagesState?
      pagesList = getLocalStore('pagesState')
      pageListGet pagesList.page_ids

    # Save current index page view to sessionStorage 
    if localStorage?
      $('.edit_page').live 'click', ->
        pagesList = page_ids: []
        $('.page_fold_arrow_ccw').each ->
          pagesList.page_ids.push $(@).parent().attr('data-page_id')
        setLocalStore 'pagesState', pagesList

    # Show the page_parts field on edit page
    $('fieldset.page_parts legend').siblings().first().show()
    $('fieldset.page_parts legend').find('span').removeClass('rotate-ccw')

    # page parts ajax spinner 
    $('ol#page_parts_nav a').on 'ajax:beforeSend', ->
      $('.page_parts div.spinner_wrapper .spinner').removeClass 'hidden'
    $('ol#page_parts_nav a').on 'ajax:success', ->
      $('.page_parts div.spinner_wrapper .spinner').addClass 'hidden'

    # on the index page rotate arrow if the child has child_pages.
    # Then hide and show the spinner before and after ajax call
    $('.page_fold_arrow').live 'ajax:beforeSend', ->
      pageList = $(@).parent()
      pageFoldArrow = $(@)
      if pageList.hasClass('child_pages')
        if pageFoldArrow.hasClass('page_fold_arrow_ccw')
          pageList.children('.pages').first().slideUp 'slow', ->
            pageFoldArrow.removeClass 'page_fold_arrow_ccw'
          false
        else
          pageList.children('.pages').first().slideDown 'slow', ->
            pageFoldArrow.addClass 'page_fold_arrow_ccw'
          false
      else
        contentTop = $('#content').offset().top
        pageFoldTop = $(this).offset().top
        $('.spinner').css('top', pageFoldTop - contentTop - 72)
        $('.spinner').removeClass 'hidden'
    $('.page_fold_arrow').live 'ajax:complete', ->
      unless $('.spinner').hasClass 'hidden'
        $('.spinner').addClass 'hidden'
        $('.spinner').css('top', 0)

    # change page part nav name 
    $('li.page_part_name input').on 'change', ->
      pp_id = $(this).parent().siblings().last().children().first().attr 'value'
      page_part_nav_link = $('ol#page_parts_nav #' + pp_id + '_nav').find('a')
      old_val = page_part_nav_link.html()

      /* if new value isn't blank change it if it is set it back to the old value */
      if $(this).attr('value').trim()
        page_part_nav_link.html $(this).attr('value')
      else
        page_part_nav_link.html old_val
        $(this).attr 'value', old_val
