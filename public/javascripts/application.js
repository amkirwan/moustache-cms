// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){
  var editor = ace.edit("layout_content");  
  var HTMLMode = require("ace/mode/html").Mode;
  editor.getSession().setMode(new HTMLMode());
  editor.setTheme("ace/theme/clouds");
});
