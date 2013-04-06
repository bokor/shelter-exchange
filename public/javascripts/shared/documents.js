/*!------------------------------------------------------------------------
 * shared/documents.js
 * Copyright (c) 2011 Designwaves, LLC. All rights reserved.
 * ------------------------------------------------------------------------ */
var Documents = {
  initUploader: function(attachable_id, documents, maxFilesAllowed){
    // Initialize JQuery File Upload
    $('#document_uploader_' + attachable_id).fileupload({
      //maxFileSize: 5000000,
      autoUpload: true,
      maxNumberOfFiles: maxFilesAllowed
      // dropZone: null
    });

    // Preload Files
    $('#document_uploader_' + attachable_id).each(function (e) {
      if (documents && documents.length) {
        $(this).fileupload('option', 'maxNumberOfFiles', maxFilesAllowed - documents.length);
        $(this).fileupload('option', 'done').call(this, null, {result: documents});
      }
    });
   },
   closeDialog: function(){
    $('.qtip.ui-tooltip').qtip('hide');
    return false;
   }
};

