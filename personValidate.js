function validate()
{ 
   if( document.newUserRegistration.firstname.value == "" )
   {
     alert( "Please provide your First Name!" );
     document.newUserRegistration.firstname.focus() ;
     return false;
   }
   if( document.newUserRegistration.lastname.value == "" )
   {
     alert( "Please provide your Last Name!" );
     document.newUserRegistration.lastname.focus() ;
     return false;
   }
   if( document.newUserRegistration.personid.value == "" )
   {
     alert( "Please provide your Person ID!" );
     document.newUserRegistration.personid.focus() ;
     return false;
   }  
   if (( document.newUserRegistration.personid.value !== parseInt(document.newUserRegistration.personid.value) ))
   {
     alert( "Please provide valid Person ID!" );
     document.newUserRegistration.personid.focus() ;
     return false;
   }
   if( document.newUserRegistration.address.value == "" )
   {
     alert( "Please provide your Address!" );
     document.newUserRegistration.address.focus() ;
     return false;
   }

 var email = document.newUserRegistration.emailid.value;
  atpos = email.indexOf("@");
  dotpos = email.lastIndexOf(".");
 if (email == "" || atpos < 1 || ( dotpos - atpos < 2 )) 
 {
     alert("Please enter correct email!")
     document.newUserRegistration.emailid.focus() ;
     return false;
 }
  if( document.newUserRegistration.mobileno.value == "" ||
           document.newUserRegistration.mobileno.value.length != 10 )
   {
     alert( "Please provide a 10 digit Phone Number." );
     document.newUserRegistration.mobileno.focus() ;
     return false;
   } 
   return( true );
}
