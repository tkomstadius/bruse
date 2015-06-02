@bruseApp.factory 'FilePreparer', ['JSTagsCollection', 'MimeDictionary', 'defaults', (JSTagsCollection, MimeDictionary, defaults) ->
  return (file) ->
    _f = file
    # extract tag names
    onlyTags = _.pluck(file.tags, 'name')
    # add pretty file type
    _f.prettyFiletype = MimeDictionary.prettyType(file.filetype)
    # append jsTag stuff to every file
    _f.unsavedTags = new JSTagsCollection(onlyTags)
    # load global default for jsTagOptions
    _f.jsTagOptions = angular.copy(defaults.jsTagOptions)
    # append unsaved tags
    _f.jsTagOptions.tags = _f.unsavedTags
    return _f
]
