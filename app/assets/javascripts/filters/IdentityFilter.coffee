@bruseApp.filter 'IdentityFilter', ->
  (files, identity_filter) ->
    if identity_filter
      filtered = []
      i = 0
      while i < files.length
        if files[i].identity.id == identity_filter
          filtered.push files[i]
        i++
      filtered
    else
      files
