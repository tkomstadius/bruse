@bruseApp.controller 'redirectCtrl', ['$location', ($location) ->
  window.location.replace($location.$$path)
]
