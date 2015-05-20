@bruseApp.directive 'bDropzone', () ->
  # restriction to only match the attribute name
  restrict: 'A'
  # create an isolate scope to map the outer scope to our directives inner scope
  scope: {
    # use = when the attribute name is the same as the value in directive
    # used as: file="", else use var: '=file'
    theFiles: '='
    images: '='
    drop: '='
    saved: '='
    info: '='
    noType: '='
  }
  # use link when we want to modify the DOM
  # scope - angular scope object
  # element - element that this directive matches
  # attrs - hash object with key/value paris
  link: (scope, element, attrs) ->

    # prevent default browser behavior (loading file) 
    # copy restricts the type of drag the user can perform
    processDragOverOrEnter = (event) ->
      if event?
        event.preventDefault()
      (event.originalEvent or event).dataTransfer.effectAllowed = 'move'
      false

    # handle files from datatransfer files
    addFile = (file) ->
      obj = {}
      obj.name = file.name
      obj.type = file.type
      reader = new FileReader()
      
      reader.onload = (evt) ->
        # update bindings
        scope.$apply ->
          obj.data = reader.result.split(",")[1]
          scope.drop = true
          scope.info = ''
          scope.theFiles.push obj

          if file.type in ['image/jpeg', 'image/png', 'image/tiff', 'image/gif']
            scope.images.push evt.target.result
          return

      if file.type != ''
        reader.readAsDataURL file
      else
        scope.$apply ->
          scope.noType = scope.noType + file.name + " has no type and can not be saved"
      return false

    # handle files from directory?
    # does not support wierder types such as .cpp and .xcf
    addFileFromDir = (entry) ->
      entry.file(addFile)


    addEntries = (entry) ->
      if entry.isFile
        addFileFromDir(entry)
      else if entry.isDirectory
        dirReader = entry.createReader()
        # call the reader.readEntries until no more results are returned
        dirReader.readEntries((ent) ->
          i = 0
          while i < ent.length
            addEntries(ent[i])
            i++
        )

    # bind to events dragover and dragenter
    element.bind 'dragover', processDragOverOrEnter
    element.bind 'dragenter', processDragOverOrEnter 

    # bind to drop event on the element, trigger FileReader API
    # on drop events we stop browser and read the dropped file via the FileReader
    # the resulting dropped file is bound to the scope of this directive
    element.bind 'drop', (event) ->
      if event?
        event.preventDefault()
      # get both items and files for different use case
      types = event.originalEvent.dataTransfer.types
      url = []
      if "text/uri-list" in types
        console.log types
        url = event.originalEvent.dataTransfer.getData("text/uri-list")
      else
        files = event.originalEvent.dataTransfer.files
      items = event.originalEvent.dataTransfer.items
      
      
      scope.noType = ''
      i = 0

      while i < items.length
        # webkit implementation of HTML5 API
        # entry objects act as interfaces to access FileSystem API

        entry = items[i].webkitGetAsEntry()
        if url.length > 0
          scope.images = []
          scope.saved = false
          console.log "hej"
          # make a file of the url
        else if entry.isFile
          # if it is not a folder, use the datatransfer files
          scope.images = []
          scope.saved = false
          addFile(files[i])

        else if entry.isDirectory
          # uses entry to read files, cannot handle wierd types
          scope.images = []
          scope.saved = false
          addEntries(entry)
            
        i++

