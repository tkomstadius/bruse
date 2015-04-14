@bruseApp.directive('bruseDrop', () ->
  # restriction to only match the attribute name
  restrict: 'A'
  # create an isolate scope to map the outer scope to our directives inner scope
  scope: {
    file: '='
    fileName: '='
  }
  link: () ->

    # bind to events dragover and dragenter, prevent default browser behavior
    # (displaying), copy restricts the type of drag the user can perform
    processDragOverOrEnter = (event) ->
      event?.preventDefault()
      event.dataTransfer.effectAllowed = 'copy'
      false

)