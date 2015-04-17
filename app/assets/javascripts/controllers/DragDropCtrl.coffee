# TODO: create modal for save option?
@bruseApp.controller('DragDropCtrl', ($scope) ->
    $scope.fileObject = null
    $scope.fileName = ''
    $scope.dataObject = {}
    $scope.imageFile = null
    $scope.isDropped = false
    $scope.saveTo = ''

    $scope.saveOpt = (location) ->
      $scope.isDropped = false
      $scope.saveTo = location
)

@bruseApp.directive('bDropzone', () ->
  # restriction to only match the attribute name
  restrict: 'A'
  # create an isolate scope to map the outer scope to our directives inner scope
  scope: {
    # use = when the attribute name is the same as the value in directive
    file: '=' # used as: file="", else use var: '=file'
    name: '='
    image: '='
    drop: '='
    object: '='
  }
  # use link when we want to modify the DOM
  # scope - angular scope object
  # element - element that this directive matches
  # attrs - hash object with key/value paris
  link: (scope, element, attrs) ->
    # object = {}

    # prevent default browser behavior (loading file) 
    # copy restricts the type of drag the user can perform
    processDragOverOrEnter = (event) ->
      if event?
        event.preventDefault()
      (event.originalEvent or event).dataTransfer.effectAllowed = 'move'
      false
    validMimeTypes = attrs.bDrop

      #isTypeValid = (type) ->
      #if validMimeTypes in [undefined, ''] or validMimeTypes.indexOf(type) > -1
      #  true
      #else
      #  alert "Invalid file type. File must be one of the following types #{validMimeTypes}"
      #  false

    # bind to events dragover and dragenter
    element.bind 'dragover', processDragOverOrEnter
    element.bind 'dragenter', processDragOverOrEnter 

    # bind to drop event on the element, trigger FileReader API
    # on drop events we stop browser and read the dropped file via the FileReader
    # the resulting dropped file is bound to the image property of the scope of this directive
    element.bind 'drop', (event) ->
      if event?
        event.preventDefault()
      reader = new FileReader()
      reader.onload = (evt) ->
        # TODO: add some security checks?
        #if event.originalEvent.dataTransfer.files[0].type in validMimeTypes
          # update bindings
        scope.$apply ->
          scope.file = evt.target.result
          scope.name = reader.name
          scope.object.data = reader.result
          scope.drop = true
          if file.type == 'image/jpeg'
            scope.image = evt.target.result
          else
            scope.image = null
          console.log scope.object

      file = event.originalEvent.dataTransfer.files[0]
      reader.readAsDataURL file
      scope.object.name = file.name
      scope.object.type = file.type
      return false
)
