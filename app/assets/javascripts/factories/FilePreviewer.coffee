@bruseApp.factory 'FilePreviewer', ['MimeDictionary', 'FileHandler', (MimeDictionary, FileHandler) ->
  error_html = (file) ->
    string = '<div class="white-popup">' + file.name + ' could not be displayed...'
    if file.url
      string += "<a href='"+file.url+"' target='_blank'><button class='u-center-text'>Open in a new tab!</button></a>"
    string+="</div>"
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
            items: files
            gallery: {
              enabled: true
              preload: [0,2]
            }
            iframe: {
               markup: '<div class="mfp-iframe-scaler">'+
                          '<div class="mfp-close"></div>'+
                          '<iframe class="mfp-iframe" frameborder="0" allowfullscreen></iframe>'+
                          '<div class="mfp-title"></div>'+
                        '</div>'
            }
            callbacks: {
              markupParse: (template, values, item) ->
                values.title = item.data.title;
            }
            type: 'image'
          }, index)

]
