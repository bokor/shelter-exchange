/*!------------------------------------------------------------------------
 * app/settings.js
 * ------------------------------------------------------------------------ */
var Settings = {
  initialize: function(){
    $("#api_integration .toggle_buttons a").bind("click", function(e){
      e.preventDefault();

      // Add/Remove Classes
      $("#api_integration .toggle_buttons a").removeClass("current");
      $(this).addClass("current");

      // Show/Hide Elements from the Clicked link
      var showElementId = $(this).attr('href');
      $("#api_integration .toggle_buttons a").each(function(){
        var currentElementId = $(this).attr('href');
        if(showElementId === currentElementId)  {
          $(showElementId).show();
         } else {
          $(currentElementId).hide();
         }
      });
    });

    $("#api_integration .toggle_buttons a[href='#iframe']").trigger("click");
  },
	loadApiJson: function(url, accessToken){
    $.ajax({
      url: url,
      type: 'GET',
      dataType: 'json',
      data: {
        "access_token": accessToken
      },
      success: function(json) {
        prettyPrintJson = Settings.syntaxHighlight(JSON.stringify(json, undefined, 2));
        $("#json_pretty_print").html(prettyPrintJson);
      }
    });
	},
	syntaxHighlight: function(json){
    if (typeof json != 'string') {
         json = JSON.stringify(json, undefined, 2);
    }
    json = json.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    return json.replace(/("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, function (match) {
      var cls = 'number';
      if (/^"/.test(match)) {
          if (/:$/.test(match)) {
              cls = 'key';
          } else {
              cls = 'string';
          }
      } else if (/true|false/.test(match)) {
          cls = 'boolean';
      } else if (/null/.test(match)) {
          cls = 'null';
      }
      return '<span class="' + cls + '">' + match + '</span>';
    });
	}
};

