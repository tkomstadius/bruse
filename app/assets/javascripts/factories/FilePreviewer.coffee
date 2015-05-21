@bruseApp.factory 'FilePreviewer', ['MimeDictionary', 'FileHandler', (MimeDictionary, FileHandler) ->
  # all our previewers
  _previewers =
    ###*
     * display an image popup
     * @param  object file   the file object
     * @param  object params optional file parameters
     * @return nothing
    ###
    image: (file, params) ->
      console.log "Displaying textfile ", file.url
      FileHandler.download(file.identity, file.id).then((file) ->
        # open the returned url in a new tab
        $.magnificPopup.open({
                items: [
                  {
                    src: file.url
                    title: 'Peter & Paul fortress in SPB'
                  }
                  {
                    src: 'http://vimeo.com/123123'
                    type: 'iframe'
                  }
                  {
                    src:  'http://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Peter_%26_Paul_fortress_in_SPB_03.jpg/800px-Peter_%26_Paul_fortress_in_SPB_03.jpg'
                    type: 'inline'
                  }
                  {
                    src: '<div class="white-popup">Popup from HTML string</div>'
                    type: 'inline'
                  }
                  {
                    src: 'get/94b70e3eeed6f7f81869405eee8c44fd'
                    type: 'inline'
                  }
                ]
                gallery: enabled: true
                type: 'image'
              }, 0)
        )


    iframe: (file, params) ->
      console.log "Displaying textfile ", file.filetype
      FileHandler.download(file.identity, file.id).then((data) ->
        # open the returned url in a new tab
        $.magnificPopup.open({
                items:{
                  src: data.url
                },
                type: 'iframe'
              }, 0)
        )



    noTemplate: (file, params) ->
      # display something about not beeing able to display that file
      console.warn "Template for filetype '#{file.filetype}' not found."

  # return function to call from external resources
  return (file, params) ->
    # default params value
    params ?= {}
    # get template function name
    templateName = MimeDictionary.viewTemplate(file.filetype)
    # call template function
    _previewers[templateName](file, params)

]
