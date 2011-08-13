// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
  window.editor = ace.edit("code");  

  // configure editor
  var HTMLMode = require("ace/mode/html").Mode;
  window.editor.getSession().setMode(new HTMLMode());
  window.editor.setTheme("ace/theme/textmate");

  window.editor.keyBinding.setKeyboardHandler(require('ace/keyboard/keybinding/vim').Vim);
  window.editor.getSession().setTabSize(2);
  window.editor.getSession().setUseSoftTabs(true);

  var theContent = $('textarea#layout_content').val();
  
  window.editor.getSession().setValue(theContent);

  $('.code').submit(function() {
    var content = window.editor.getSession().getValue();
    $('textarea#layout_content').val(content);
  });
});
