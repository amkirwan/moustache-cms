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
    
    root.sortablePageList $('.sortable').first()

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

    $('.preview').click 'ajax:beforeSend', ->
      pagePartNames = []
      $('#page_parts_nav .tab').each ->
        pagePartNames.push 'page_part_' + $(@).text()

      text = []
      $.each MoustacheEditor.editors, (index, editor) ->
        text.push editor.getValue()

      dataObject = {} 
      $.each pagePartNames, (index, value) ->
        dataObject[value] = text[index]

      @.data = JSON.stringify(dataObject)

    # page parts ajax spinner 
    $('ol#page_parts_nav a').live 'ajax:beforeSend', ->
      $('.page_parts div.spinner_wrapper .spinner').removeClass 'hidden'
    $('ol#page_parts_nav a').live 'ajax:success', ->
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

    # Change page part nav name 
    $('li.page_part_name input').live 'change', ->
      pp_id = $(this).parent().siblings().last().children().first().attr 'value'
      page_part_nav_link = $('ol#page_parts_nav #' + pp_id + '_nav').find('a')
      old_val = page_part_nav_link.html()

      # If new value isn't blank change it if it is set it back to the old value 
      if $(this).attr('value').trim()
        page_part_nav_link.html $(this).attr('value')
      else
        page_part_nav_link.html old_val
        $(this).attr 'value', old_val

    # edit page custom confirm delete
    if $('body.pages').length
      $.rails.allowAction = (element) ->
        answer = false
        message = element.data 'confirm'
        if !message
          return true

        if $.rails.fire(element, 'confirm') 
          answer = $.rails.confirm message
          list = element.parentsUntil('li').parent() 
          if answer && list.children().first().hasClass('page_fold_arrow')
            page_name = $('#' + list.attr('id') + ' > ' + 'strong').text()
            answer = $.rails.confirm('Deleteing the page ' + page_name + ' will delete the page and all child pages it is the parent of!')
        answer

    # Add custom preview event handler
    $('.preview').on 'preview', (event, href) ->
      window.location.href = href

    # Handle page preview   
    $('.preview').click (e) ->
      e.preventDefault()
      $.each MoustacheEditor.editors, (index, editor) ->
        editor.updateTextarea()
      form = $('form.page')
      action = form.attr('action').split('/')
      page_id = action[action.length - 1]
      url = '/admin/pages/' + page_id + '/preview'
      disabled = form.find(":input[type=hidden]")
      disabled.splice(0,3) #remove hidden fields needed to submit form for rails 
      disabled.each -> $(@).attr('disabled', 'disabled') # disable hidden form elements so they are not serialized
      $.post url, form.serialize(), -> 
        $('.preview').trigger 'preview', [$('.preview').attr('href')]
      disabled.each -> $(@).removeAttr('disabled') # enable form elements so they can be submit for an update

        
    # Display Moustache Tags Helpers  
    $('.documentation').fancybox 
      maxHeight: 400
      maxWidth: 600
      height: '70%'
    

