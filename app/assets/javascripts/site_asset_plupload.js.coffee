jQuery ->
  $(document).ready ->
    $('#uploader').pluploadQueue
      runtimes: 'gears,flash,html5'
      unique_names: true
      url: 'admin/asset_collections'
      multipart: true
      multipart_params:
        authenticity_token: '10'
