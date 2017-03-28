form = $( "#form" );
form.submit(function( event ) {
  if( $( "#url" ).val().length === 0 ) {
  $( "#url" ).val( "zadejte něco..." ).fadeOut( 500 );
  $( "#url" ).val( "" ).fadeIn( 500 );
  event.preventDefault();
  }
 });
