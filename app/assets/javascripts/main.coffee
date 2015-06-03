@bruseApp = angular.module 'bruseApp', ['ngRoute', 'jsTag']

@bruseApp.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
  $routeProvider.
    when('/service/:identity_id/files/add', {
      path: 'file',
      templateUrl: 'fileBrowse',
      controller: 'ImportCtrl'
    }).
    when('/service/:identity_id/files/add/tag', {
      path: 'tag',
      templateUrl: 'tagCreate',
      controller: 'TagCtrl'
    }).
    otherwise({
      controller : ($location) ->
        window.location.replace($location.$$path);
      ,
      template : "<div></div>"
    })
  $locationProvider.html5Mode(true)
]

@bruseApp.constant 'defaults',
  jsTagOptions:
    breakCodes: [32, 13, 9, 44] #space, enter, tab, comma
    texts:
      inputPlaceHolder: "Tags..."
      removeSymbol: String.fromCharCode(215)
