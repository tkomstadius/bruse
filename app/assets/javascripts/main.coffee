@bruseApp = angular.module 'bruseApp', ['ngRoute']

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
      path: 'redirect',
      templateUrl: 'redirect',
      controller: 'redirectCtrl'
    })
  $locationProvider.html5Mode(true)
]
