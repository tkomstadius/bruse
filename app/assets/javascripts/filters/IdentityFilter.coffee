@bruseApp.filter 'IdentityFilter', ->
  (files, identities) ->
    _.map(files, (file) ->
      obj = {}
      obj[file.identity.name] = true
      _.includes(identities, obj)
      )
