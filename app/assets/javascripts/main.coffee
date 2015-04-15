@bruseApp = angular.module 'bruseApp', ['ngRoute']

@bruseApp.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->
  $routeProvider.
    when('/service/:identity_id/files/add', {
      path: 'file',
      templateUrl: 'fileBrowse',
      controller: 'FileCtrl'
    }).
    otherwise({
      redirectTo: '/'
    })
  $locationProvider.html5Mode(true)
]
