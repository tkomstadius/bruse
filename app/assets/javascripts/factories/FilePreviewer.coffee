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
      console.log "Displaying image ", file.name
      # open the returned url in a new tab
      $.magnificPopup.open({
              items:{
                  src: '/preview/'+file.id
                  title: file.name
                }
              gallery: enabled: true
              type: 'image'
            }, 0)


    iframe: (file, params) ->
      console.log "Displaying iframe-file ", file.name
      # open the returned url in a new tab
      $.magnificPopup.open({
              items:{
                src: '/preview/'+file.id
              },
              type: 'iframe'
            }, 0)



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
