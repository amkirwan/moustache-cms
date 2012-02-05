$(document).ready -> 

  class Mode
    constructor: (@name, @desc, @klass, extensions) ->
      @mode = new @klass()
      @extRe = new RegExp("^.*\\.(" + extensions.join("|") + ")$", "g")

  class HandlebarEditor
    constructor: (@elementId) ->
      @element = $('#' + @elementId)
      @editor = ace.edit @elementId
      @editor.setTheme "ace/theme/twilight"

    @modes = [  
      new Mode("css", "CSS", ace.require("ace/mode/css").Mode, ["css"]),
      new Mode("html", "HTML", ace.require("ace/mode/html").Mode, ["html", "htm"]),
      new Mode("javascript", "JavaScript", ace.require("ace/mode/javascript").Mode, ["js"]),
      new Mode("markdown", "Markdown", ace.require("ace/mode/markdown").Mode, ["md", "markdown"]),
      new Mode("textile", "Textile", ace.require("ace/mode/textile").Mode, ["textile"])
      ]

    @modesByName: {}
    for mode in @modes
      @modesByName[mode.name] = mode

    contentSettings: (filterText) ->
      @editor.getSession().setMode HandlebarEditor.modesByName[filterText].mode

    hideUpdateTextarea: ->
      $('.content_submit').hide()
      $('.site_prop').submit =>
        #update hidden textarea
        @element.parent().next().find('textarea').val @editor.getSession().getValue()

    createEditor: (elementId) ->
      @editor = ace.edit elementId
      @editor.setTheme "ace/theme/twilight"

    toString: ->
      'elementId =' + @elementId + ' ' +
      'element =' + @element.toString() + ' ' +
      'editor =' + @editor.toString()

  if $("body.layouts #layout_content").length
    hbEditor = new HandlebarEditor("layout_content")
    hbEditor.hideUpdateTextarea()
    hbEditor.contentSettings "html"

  else if $("body.snippets #snippet_content").length
    hbEditor = new HandlebarEditor("snippet_content")
    hbEditor.hideUpdateTextarea()

    $('#snippet_filter_name').each ->
      hbEditor.contentSettings $(@).val() 
    $('#snippet_filter_name').change ->
      hbEditor.contentSettings $(@).val()

  else if $("body.articles #article_content").length
    hbEditorSub = new HandlebarEditor("article_subheading_content")
    hbEditorSub.hideUpdateTextarea()

    hbEditorContent = new HandlebarEditor("article_content")
    hbEditorContent.hideUpdateTextarea()

    $('#article_filter_name').each ->
      hbEditorSub.contentSettings $(@).val() 
      hbEditorContent.contentSettings $(@).val() 
    $('#article_filter_name').change ->
      hbEditorSub.contentSettings $(@).val()
      hbEditorContent.contentSettings $(@).val() 

  else if $("body.pages .page_parts").length
    filters = []
    $('.page_parts select').each -> 
      filters.push @

    editors = [] 
    $('.page_part_content').each (index) ->
      editor = new HandlebarEditor @.id
      editors.push editor
      editor.contentSettings $(filters[index]).val()
      editor.hideUpdateTextarea()

    # hide after adding editor to view otherwise they don't render correctly
    $('ol.page_part').each ->
      $(@).hide()
