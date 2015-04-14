@bruseApp.directive('bruseDrop', () ->
  link: () ->

    # bind to events dragover and dragenter, prevent default browser behavior
    # (displaying), copy restricts the type of drag the user can perform
    processDragOverOrEnter = (event) ->
      event?.preventDefault()
      event.dataTransfer.effectAllowed = 'copy'
      false

)