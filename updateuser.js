function validate()
{ 
   if( document.updateUser.username.value == "" )
   {
     alert( "Please provide your User Name!" );
     document.updateUser.username.focus() ;
     return false;
   }
 var email = document.updateUser.emailid.value;
  atpos = email.indexOf("@");
  dotpos = email.lastIndexOf(".");
 if (email == "" || atpos < 1 || ( dotpos - atpos < 2 )) 
 {
     alert("Please enter correct email!")
     document.updateUser.emailid.focus() ;
     return false;
 }
  if( document.updateUser.mobileno.value == "" ||
           document.updateUser.mobileno.value.length != 10 )
   {
     alert( "Please provide a 10 digit Phone Number." );
     document.updateUser.mobileno.focus() ;
     return false;
   } 

   return (true);	
}

