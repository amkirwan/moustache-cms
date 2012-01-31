//= require ace/build/src/ace-uncompressed-noconflict
//= require ace/build/src/theme-twilight-noconflict
//= require ace/build/src/mode-html-noconflict
//= require_self

$(document).ready(function() {
  if ($("body.layouts"))  {
    var editor = ace.edit("layout_content");
    editor.setTheme("ace/theme/twilight");

    var HTMLMode = ace.require("ace/mode/html").Mode;
    editor.getSession().setMode(new HTMLMode());

    $('.code_submit').hide();
    $('.site_prop').submit(function() {
      $('.code_submit textarea').val(editor.getSession().getValue());
    });
  } else if {
    var editor = ace.edit("layout_content");
    editor.setTheme("ace/theme/twilight");

    var HTMLMode = ace.require("ace/mode/html").Mode;
    editor.getSession().setMode(new HTMLMode());

    $('.code_submit').hide();
    $('.site_prop').submit(function() {
      $('.code_submit textarea').val(editor.getSession().getValue());
    });
  }
});
