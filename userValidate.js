function validate()
{ 
   if( document.newUserRegistration.username.value == "" )
   {
     alert( "Please provide your User Name!" );
     document.newUserRegistration.username.focus() ;
     return false;
   }
   if( document.newUserRegistration.password.value == "" )
   {
     alert( "Please provide your Password!" );
     document.newUserRegistration.password.focus() ;
     return false;
   }
   if( document.newUserRegistration.Class.value == "-1" )
   {
     alert( "Please Choose your Class!" );
     document.newUserRegistration.Class.focus() ;
     return false;
   }  
   return( true );
}
