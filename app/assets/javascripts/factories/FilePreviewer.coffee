@bruseApp.factory 'FilePreviewer', ['MimeDictionary', (MimeDictionary) ->
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

    ###*
     * display an image popup
     * @param  object file   the file object
     * @param  object params optional file parameters
     * @return nothing
    ###
    plaintext: (file, params) ->
      console.log "Displaying textfile ", file.name

    ###*
     * display an image popup
     * @param  object file   the file object
     * @param  object params optional file parameters
     * @return nothing
    ###
    pdf: (file, params) ->
      console.log "Displaying pdf ", file.name

    ###*
     * display default error that there is no preview for this file
     * @param  object file   the file object
     * @param  object params optional file parameters
     * @return nothing
    ###
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
