 function validateName(fpos, epos) {
   var v=/[^A-Z0-9-." "]/gi;

   var t=document.forms[fpos].elements[epos].value;
   if (v.test(t) || (t.length < 1 || t.length > 35)) {
       alert('Course names can only contain the characters a-z, A-Z, 0-9, dot ("."), dash("-"), underscore ("_"), and spaces and cannot be more than 35 characters.')
       return false;  
     } else {   
       return true;
     }
  };

