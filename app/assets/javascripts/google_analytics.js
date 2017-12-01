$(document).on('turbolinks:load', function() {
  (function(i, s, o, g, r, a, m) {
      i['GoogleAnalyticsObject'] = r;
      i[r] = i[r] ||
      function() {
        (i[r].q = i[r].q || []).push(arguments)
      }, i[r].l = 1 * new Date();
      a = s.createElement(o),
      m = s.getElementsByTagName(o)[0];
      a.async = 1;
      a.src = g;
      m.parentNode.insertBefore(a, m)
    })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

  ga('create', '<%= GOOGLE_ANALYTICS_SETTINGS["tracking_code"] %>', 'auto');
  var user_type =  '<%= user_type %>';
  ga('set', 'dimension1', user_type);
  var list_type =  '<%= list_type %>';
  ga('set', 'dimension2', list_type);
  ga('send', 'pageview');

  ga(function(tracker) {
          var clientId = tracker.get('clientId');
          var element = $('.ga_user_id');
          element.val(clientId);
        });
 });