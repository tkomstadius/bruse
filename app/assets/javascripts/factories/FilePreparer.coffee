@bruseApp.factory 'FilePreparer', ['JSTagsCollection', (JSTagsCollection) ->
  return (file) ->
    _f = file
    # extract tag names
    onlyTags = _.pluck(file.tags, 'name')
    # append jsTag stuff to every file
    _f.unsavedTags = new JSTagsCollection(onlyTags)
    # TODO: use some sort of default for bruse jsTags here?
    _f.jsTagOptions =
      breakCodes: [32, 13, 9, 44] #space, enter, tab, comma
      tags: _f.unsavedTags
      texts:
        inputPlaceHolder: "Tags..."
        removeSymbol: String.fromCharCode(215)
    return _f
]
