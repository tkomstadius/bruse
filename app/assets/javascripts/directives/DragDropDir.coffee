# TODO: check all the names
@bruseApp.directive('bruseDrop', () ->
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
      event?.preventDefault()
      event.dataTransfer.effectAllowed = 'copy'
      false

    # bind to events dragover and dragenter
    element.bind 'dragover', processDragOverOrEnter
    element.bind 'dragenter', processDragOverOrEnter 
)