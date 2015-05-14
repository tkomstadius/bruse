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



    # bind to events dragover and dragenter
    element.bind 'dragover', processDragOverOrEnter
    element.bind 'dragenter', processDragOverOrEnter 

    # bind to drop event on the element, trigger FileReader API
    # on drop events we stop browser and read the dropped file via the FileReader
    # the resulting dropped file is bound to the image property of the scope of this directive
    element.bind 'drop', (event) ->
      if event?
        event.preventDefault()
      temp = event.dataTransfer.files
      #console.log temp
      i = 0
      t = undefined
      while t = temp[i]
        reader = new FileReader()
        # console.log t
        if t?
          # console.log t[0]
          file = t[0]
          name = t.name
          type = t.type
          reader.readAsDataURL t
        
        # console.log temp
        reader.onload = (evt) ->
          # TODO: when working, make sure that there is a file type
          scope.$apply ->
            scope.file.push evt.target.result
            # console.log scope.file
            scope.fileName = name if angular.isString scope.fileName
        i++
      return false
)
