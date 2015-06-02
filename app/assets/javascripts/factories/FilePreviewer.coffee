@bruseApp.factory 'FilePreviewer', ['MimeDictionary', 'FileHandler', (MimeDictionary, FileHandler) ->
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
        return {
          src: '<div class="white-popup">'+file.name+' could not be displayed...</div>'
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
