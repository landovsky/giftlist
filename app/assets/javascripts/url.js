$(document).on('turbolinks:load', function() {
  $("#urlform").submit( function(event) {   // zamezí odeslání prázdného formu
      var url = $("#url");
      if ( url.val().length === 0 ) {
        url.fadeOut(500);
        url.fadeIn(500);
        $("#url").removeClass('waiting');
        event.preventDefault();
      }
    });

    $('#url').on('paste', function () {       // submit on paste
        var element = this;
        setTimeout(function () {
          var text = $(element).val();
          $("#url").addClass('waiting');
          $("#urlform").submit();
        }, 100);
    });

    $('#url').on('blur', function () {        // submit on lost focus (klikne vedle)
      var url = $("#url");
      if ( url.val().length === 0 ) {
        url.fadeOut(500);
        url.fadeIn(500);
        $("#url").removeClass('waiting');
        event.preventDefault();
      } else {
        $("#url").addClass('waiting');
        $("#urlform").submit();
      }
    });
    
    $('#submit_giftform').one('click', function(event) {
      $("#giftform").submit();
      $( this ).off( event );
    });
 });