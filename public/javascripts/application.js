// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(document).ready(function() {
  /*
  var editor = CodeMirror.fromTextArea(document.getElementById("layout_content
  "), {});
  */
  $('code.html textarea').addCodeMirrorEditor();
  
})

/* codemirror */
;(function($) {
  $.fn.addCodeMirrorEditor = function() {
    
    return this.each(function() {
      var editor = CodeMirror.fromTextArea(this, {
        mode: "text/html",
        tabMode: "indent",
        height: "400px",
        reindentOnLoad: true
      });
    })
  }
})(jQuery);
