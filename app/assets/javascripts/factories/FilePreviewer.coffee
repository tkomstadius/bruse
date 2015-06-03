@bruseApp.factory 'FilePreviewer', ['MimeDictionary', 'FileHandler', (MimeDictionary, FileHandler) ->
  error_html = (file) ->
    string = '<div class="white-popup">' + file.name + ' could not be displayed...'
    if file.url
      string += "<a href='"+file.url+"' target='_blank'><button class='u-center-text'>Open in a new tab!</button></a>"
    string += "</div>"
    return string

  # return function to call from external resources
  return (index, files) ->
    # Create a suitable array for the popup
    files = _.map(files, (file) ->
      if MimeDictionary.viewTemplate(file.filetype) != 'noTemplate'
        return {
          src: '/preview/'+file.id
          title: file.name
          type: MimeDictionary.viewTemplate(file.filetype)
        }
      else
        console.log "Could not preview " + file.filetype
        return {
          src: error_html(file)
          type: 'inline'
        }
      )
    # open the returned url in a new tab
    $.magnificPopup.open({
            items: files,
            gallery:{
              enabled: true,
              preload: [0,2]
            },
            type: 'image'
          }, index)

]
