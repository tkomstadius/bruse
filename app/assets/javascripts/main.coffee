@bruseApp = angular.module 'bruseApp', ['ngRoute', 'jsTag']

@bruseApp.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
  $routeProvider.
    when('/service/:identity_id/files/add', {
      path: 'file',
      templateUrl: 'fileBrowse',
      controller: 'FileCtrl'
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
