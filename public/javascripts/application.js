// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function(){

  // configure editor
  var editorSettings = { nameSpace: 'html' };
  $('textarea#layout_content').markItUp(mySettings);
});
