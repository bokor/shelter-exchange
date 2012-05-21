/*!------------------------------------------------------------------------
 * shared/photos.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
 var Photos = {	
 	initGallery: function(photos){
 	    Galleria.configure({
            transition: 'fade', 
            imageCrop: "landscape",
            thumbCrop: false,
            autoplay: 7000,
            clicknext: true,
            _showFullscreen: false,
            // preload: 1,
            dataSource: photos
        });
        Galleria.run('#photo_gallery');
     }, 
     refreshGallery: function(attachable_name, id){
         $.ajax({
   		     url: "/"+attachable_name+"/"+id+"/photos/refresh_gallery",
   		     type: "get",
   			 dataType: 'json'
   		 }).done(function (data) {
             Galleria.ready(function(options) {
                  this.load(data);
              });
         });
     },
     initUploader: function(photos, maxFilesAllowed){
         // Initialize JQuery File Upload
     	 $('#photo_uploader').fileupload({
             // maxFileSize: 5000000,
             acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        	 autoUpload: true,
             maxNumberOfFiles: maxFilesAllowed
             // dropZone: null
         });
         
         // Preload Files
         $('#photo_uploader').each(function (e) {
             if (photos && photos.length) {
                 $(this).fileupload('option', 'maxNumberOfFiles', maxFilesAllowed - photos.length);
                 $(this).fileupload('option', 'done').call(this, null, {result: photos});
                 
             }
         });
     },
     closeDialog: function(){
        $('.qtip.ui-tooltip').qtip('hide');
        return false;
     }
};


 
