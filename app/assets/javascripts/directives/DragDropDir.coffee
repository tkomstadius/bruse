# TODO: check all the names
@bruseApp.directive('bDrop', () ->
  # restriction to only match the attribute name
  restrict: 'A'
  # create an isolate scope to map the outer scope to our directives inner scope
  scope: {
    # use = when the attribute name is the same as the value in directive
    file: '=' # used as: file="", else use var: '=file'
    fileName: '='
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

    validMimeTypes = attrs.bDrop

    isTypeValid = (type) ->
      if validMimeTypes in [undefined, ''] or validMimeTypes.indexOf(type) > -1
        # return true if no mime types are provided
        true
      else
        alert "Invalid file type. File must be one of the following types #{validMimeTypes}"
        false

    # bind to events dragover and dragenter
    element.bind 'dragover', processDragOverOrEnter
    element.bind 'dragenter', processDragOverOrEnter 
    console.log scope.file

    # bind to drop event on the element, trigger FileReader API
    # on drop events we stop browser and read the dropped file via the FileReader
    # the resulting dropped file is bound to the image property of the scope of this directive
    element.bind 'drop', (event) ->
      if event?
        event.preventDefault()
      reader = new FileReader()
      reader.onload = (evt) ->
        # TODO: add some security checks?
        if isTypeValid(type)
          scope.$apply ->
            scope.file = evt.target.result
            scope.fileName = name if angular.isString scope.fileName
      if files?
        console.log event.dataTransfer.files[0]
        file = event.dataTransfer.files[0]
        name = file.name
        type = file.type
        reader.readAsDataURL(file)
      return false
)