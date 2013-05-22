/*!------------------------------------------------------------------------
 * shared/social.js
 * ------------------------------------------------------------------------ */
$(function(){

  if ($(".social").length > 0){

    /* Social Media - Facebook Like
    /*----------------------------------------------------------------------------*/
    (function(d, s, id) {
      var js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return;
      js = d.createElement(s); js.id = id;
      js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));


    /* Social Media - Pintrest Pin it
    /*----------------------------------------------------------------------------*/
    (function() {
        window.PinIt = window.PinIt || { loaded:false };
        if (window.PinIt.loaded) return;
        window.PinIt.loaded = true;
        function async_load(){
            var s = document.createElement("script");
            s.type = "text/javascript";
            s.async = true;
            if (window.location.protocol == "https:")
                s.src = "https://assets.pinterest.com/js/pinit.js";
            else
                s.src = "http://assets.pinterest.com/js/pinit.js";
            var x = document.getElementsByTagName("script")[0];
            x.parentNode.insertBefore(s, x);
        }
        if (window.attachEvent)
            window.attachEvent("onload", async_load);
        else
            window.addEventListener("load", async_load, false);
    })();

    /* Social Media - Twitter Tweet
    /*----------------------------------------------------------------------------*/
    !function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");
  }
});

