//= require_self

function addEvent(obj, evType, fn){ 
 if (obj.addEventListener){ 
   obj.addEventListener(evType, fn, false); 
   return true; 
 } else if (obj.attachEvent){ 
   var r = obj.attachEvent("on"+evType, fn); 
   return r; 
 } else { 
   return false; 
 } 
}

function focusUsername() {
  if (document.getElementById('login_wrapper')) {
    document.getElementsByTagName('input')[2].focus();
  }
}

addEvent(window, 'load', focusUsername);
if (typeof imgSizer != 'undefined') {
  addEvent(window, 'load', imgSizer.collate);
}

