function validate()
{ 
   if( document.newUserRegistration.Year.value == "NULL" )
   {
     alert( "Please provide your the year you want to start!" );
     document.newUserRegistration.Year.focus() ;
     return false;
   }
   if( document.newUserRegistration.Month.value == "NULL" )
   {
     alert( "Please provide your the month you want to start!" );
     document.newUserRegistration.Month.focus() ;
     return false;
   }
   if( document.newUserRegistration.Day.value == "NULL" )
   {
     alert( "Please Choose your the day you want to start!" );
     document.newUserRegistration.Day.focus() ;
     return false;
   }  
   if( document.newUserRegistration.YEAR.value == "NULL" )
   {
     alert( "Please provide your the year you want to end!" );
     document.newUserRegistration.YEAR.focus() ;
     return false;
   }
   if( document.newUserRegistration.MONTH.value == "NULL" )
   {
     alert( "Please provide your the month you want to end!" );
     document.newUserRegistration.MONTH.focus() ;
     return false;
   }
   if( document.newUserRegistration.DAY.value == "NULL" )
   {
     alert( "Please provide your the day you want to end!" );
     document.newUserRegistration.DAY.focus() ;
     return false;
   }


   return( true );
}
