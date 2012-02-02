$(document).ready -> 

  class Mode
    constructor: (@name, @desc, @klass, extensions) ->
      @mode = new @klass()
      @extRe = new RegExp("^.*\\.(" + extensions.join("|") + ")$", "g")

  class HandlebarEditor
    constructor: (elementId) ->
      @editor = ace.edit elementId
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
      $('.code_submit').hide()
      $('.site_prop').submit ->
        $('.code_submit textarea').val @editor.getSession().getValue()

    createEditor: (elementId) ->
      @editor = ace.edit elementId
      @editor.setTheme "ace/theme/twilight"

  if $("body.layouts").length
    hbEditor.editor = createEditor "layout_content"

    HTMLMode = ace.require("ace/mode/html").Mode
    hbEditor.editor.getSession().setMode(new HTMLMode())

    $('.code_submit').hide()
    $('.site_prop').submit ->
      $('.code_submit textarea').val hbEditor.editor.getSession().getValue()

  else if $("body.snippets").length
    hbEditor = new HandlebarEditor("snippet_content")

    $('#snippet_filter_name').each ->
      hbEditor.contentSettings $(@).val() 
    $('#snippet_filter_name').change ->
      hbEditor.contentSettings $(@).val()
    
    hbEditor.hideUpdateTextarea()


