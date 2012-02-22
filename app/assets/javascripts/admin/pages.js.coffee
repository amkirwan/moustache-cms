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

    # if this is a new page show the general field
    $('#new_page #general_fields legend').siblings().first().show()
    $('#new_page #general_fields legend').find('span').removeClass 'rotate-ccw'

    # Show the page_parts field on edit page
    $('fieldset.page_parts legend').siblings().first().show()
    $('fieldset.page_parts legend').find('span').removeClass 'rotate-ccw'

    
    root.setSessionStore = (key, val) ->
      sessionStorage.setItem key, JSON.stringify(val)

    root.getSessionStore = (store) ->
      JSON.parse sessionStorage.getItem(store)

    highlight = (el) ->
      el.find('.edit_page').first().animate({ color: '#e2e288' }, 1000).delay(1500).animate({ color: '#d54e0e' }, 3000)
      el.find('.page_info span').first().animate({ color: '#e2e288' }, 1000).delay(1500).animate({ color: '#9C9C9C' }, 3000)
      $.cookies.del('page_created_updated_id')
      $.cookies.del('page_parent_id')

    ###
    Recursively call pageListGet with page_ids from sessionStorage and call them via ajax
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
              highlight el
          error: ->
            pageListGet page_ids
      else
        $('.spinner').addClass 'hidden'

    ###
    If the page_list and the sessionStorage pagesState exists then call call the pageListGet with the
    stored page_ids
    ###
    if $('#pages_list').length && sessionStorage?.pagesState?
      page_id = $.cookies.get('page_created_updated_id')
      # highlight root pages and pages that are children of the root page
      if $("[data-page_id='" + page_id + "']").length
        el = $("[data-page_id='" + page_id + "']")
        highlight el
      pagesList = getSessionStore('pagesState')
      # recursivley get other page parts
      pageListGet pagesList.page_ids
      # delete cookies when done getting all page parts


    # Save current index page view to sessionStorage 
    if sessionStorage?
      $('.edit_page').live 'click', ->
        pagesList = page_ids: []
        $('.page_fold_arrow_ccw').each ->
          pagesList.page_ids.push $(@).parent().attr('data-page_id')
        setSessionStore 'pagesState', pagesList



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

    # index page custom confirm delete
    $('#pages_list .delete_message').live 'ajax:beforeSend', (e) ->
      e.stopPropagation()
      if confirm($(@).attr('data-message'))
        if $(@).closest('li').hasClass('child_pages')
          if confirm('Deleteing the page ' + $(@).attr('data-title') + ' will delete the page and all child pages it is the parent of!')
            true
          else
            false
        else
          true
      else
        false


    # edit page custom confirm delete
    if $('.edit_page .delete').length
      $.rails.allowAction = (element) ->
        answer = false
        message = element.data 'confirm'
        if !message
          return true

        if $.rails.fire(element, 'confirm') 
          answer = $.rails.confirm message
          if answer && element.hasClass('child_pages')
            answer = $.rails.confirm('Deleteing the page ' + $(@).attr('data-title') + ' will delete the page and all child pages it is the parent of!')
        answer

