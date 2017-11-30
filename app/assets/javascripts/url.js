$("#urlform").submit( function(event) {   // zamezí odeslání prázdného formu
    url = $("#url");
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
      $("#url").addClass('waiting');
      $("#urlform").submit();
    });