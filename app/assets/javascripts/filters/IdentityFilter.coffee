@bruseApp.filter 'IdentityFilter', ->
  (files, identities) ->
    debugger
    _.map(files, (file) ->
      obj = {}
      obj[file.identity.name] = true
      _.includes(identities, obj)
      )
