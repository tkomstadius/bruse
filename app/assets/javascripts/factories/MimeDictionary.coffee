@bruseApp.factory 'MimeDictionary', [->
  _prettyFileNames =
    # arbitrary
    'application/atom+xml': 'atom feed'
    'application/vnd.dart': 'dart file'
    'application/ecmascript': 'ecmascript file'
    'application/json': 'json document'
    'application/javascript': 'javascript file'
    'application/octet-stream': 'binary file'
    'application/ogg': 'ogg media'
    'application/dash+xml': 'mpeg dash'
    'application/postscript': 'postscript'
    'application/rss+xml': 'rss feed'
    'application/soap+xml': 'soap file'
    'application/font-woff': 'woff font file'
    'application/xhtml+xml': 'xhtml document'
    'application/xml': 'xml document'
    'application/example': 'common file'
    # vendor-specific / common stuff
    'application/vnd.debian.binary-package': 'debian package'
    'application/vnd.google-earth.kml+xml': 'google earth kml file'
    'application/vnd.google-earth.kmz': 'google earth kmz file'
    'application/vnd.android.package-archive': 'android pkg file'
    'application/vnd.ms-xpsdocument': 'xps document'
    'text/vnd.abc': 'abc music file'
    'application/x-chrome-extension': 'chrome extension'
    'application/x-dvi': 'dvi file'
    'application/x-font-ttf': 'TrueType font file'
    'application/x-javascript': 'javascript'
    'application/x-latex': 'latex file'
    'application/x-mpegURL': 'playlist file'
    'application/x-shockwave-flash': 'flash file'
    'application/x-www-form-urlencoded': 'form data'
    'application/x-xpinstall': 'mozilla addon'
    # audio
    'audio/example': 'audio file'
    'audio/basic': 'μ-law audio'
    'audio/L24': 'audio file'
    'audio/mp4': 'mp4 audio'
    'audio/mpeg': 'mpeg file'
    'audio/ogg': 'ogg vorbis audio'
    'audio/flac': 'native flac audio'
    'audio/opus': 'opus audio'
    'audio/vorbis': 'vorbis audio'
    'audio/vnd.rn-realaudio': 'RealPlayer audio'
    'audio/vnd.wave': 'wav file'
    'audio/webm': 'webm audio'
    'audio/x-aac': 'aac audio'
    'audio/x-caf': 'apple caf audio'
    'image/x-xcf': 'gimp image'
    # compressed folders
    'application/zip': 'compressed folder'
    'application/x-zip-compressed': 'compressed folder'
    'application/x-compress': 'compressed folder'
    'multipart/x-zip': 'compressed folder'
    'application/gzip': 'compressed folder'
    'application/x-stuffit': 'compressed archive'
    'application/x-tar': 'tarball'
    'application/x-rar-compressed': 'rar compressed folder'
    'application/x-7z-compressed': '7-zip compressed file'
    # documents
    'application/pdf': 'pdf document'
    'application/vnd.oasis.opendocument.text': 'opendocument text'
    'application/vnd.oasis.opendocument.spreadsheet': 'opendocument spreadsheet'
    'application/vnd.oasis.opendocument.presentation': 'opendocument presentation'
    'application/vnd.oasis.opendocument.graphics': 'opendocument graphics'
    'application/vnd.ms-excel': 'excel spreadsheet'
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'excel spreadsheet'
    'application/vnd.ms-powerpoint': 'powerpoint presentation'
    'application/vnd.openxmlformats-officedocument.presentationml.presentation': 'powerpoint presentation'
    'application/vnd.ms-word': 'word document'
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'word document'
    'application/x-iwork-keynote-sffkey': 'keynote presentation'
    'application/vnd.google-apps.document': 'google drive document'
    'application/vnd.google-apps.presentation': 'google drive presentation'
    'application/vnd.google-apps.map': 'google drive map'
    'application/vnd.google-apps.drawing': 'google drive drawing'
    'application/vnd.google-apps.form': 'google drive form'
    'application/vnd.google-apps.spreadsheet': 'google drive spreadsheet'
    'application/vnd.google-apps.fusiontable': 'google drive fusiontable'
    # images
    'image/example': 'image file'
    'image/jpeg': 'jpeg image'
    'image/pjpeg': 'jpeg image'
    'image/png': 'png image'
    'image/bmp': 'bmp image'
    'image/tiff': 'tiff image'
    'image/svg+xml': 'svg image'
    'image/gif': 'png image'
    'image/x-icon': 'icon'
    'image/x-photoshop': 'photoshop image'
    'application/psd': 'photoshop image'
    'application/x-photoshop': 'photoshop image'
    'image/photoshop': 'photoshop image'
    'image/psd': 'photoshop image'
    'image/x-psd': 'photoshop image'
    'application/illustrator': 'illustrator image'
    # text files
    'text/example': 'text file'
    'text/cmd': 'command text file'
    'text/css': 'css text file'
    'text/csv': 'csv file'
    'text/x-c': 'c++ file'
    'text/html': 'html file'
    'text/markdown': 'markdown file'
    'text/javascript': 'javascript text file'
    'text/plain': 'text file'
    'text/rtf': 'rtf text file'
    'text/vcard': 'contact file'
    'text/xml': 'xml file'
    'text/x-gwt-rpc': 'google web toolkit data'
    'text/x-jquery-tmpl': 'jquery template'
    'text/x-markdown': 'markdown file'
    # video
    'video/example': 'video file'
    'video/avi': 'avi video'
    'video/mpeg': 'mpeg video'
    'video/mp4': 'mp4 video'
    'video/ogg': 'ogg video'
    'video/quicktime': 'quicktime video'
    'video/webm': 'webm video'
    'video/x-matroska': 'matroska video'
    'video/x-ms-wmv': 'windows video'
    'video/x-flv': 'flash video'
    # url
    'text/uri-list': 'url'

  _templateNames =
    # images
    'image/jpeg': 'image'
    'image/png': 'image'
    'image/bmp': 'image'
    'image/svg+xml': 'image'
    'image/gif': 'image'
    # text file & code
    'text/css': 'iframe'
    'text/csv': 'iframe'
    'text/x-c': 'iframe'
    'text/plain': 'iframe'
    'text/x-csrc': 'iframe'
    'text/xml': 'iframe'
    'application/x-javascript': 'iframe'
    'application/x-latex': 'iframe'
    'application/x-www-form-urlencoded': 'iframe'
    'text/javascript': 'iframe'
    # markdown
    'text/markdown': 'iframe'
    'text/x-markdown': 'iframe'
    # pdf
    'application/pdf': 'iframe'
    # audio
    'audio/mpeg': 'iframe'


  return {
    ###*
     * find a nice, readable file type from a mime type
     * @param  string   mimetype  the mime type
     * @return string             best matching file type
    ###
    prettyType: (mimetype) ->
      # if we have a pritty name for this mimetype
      if _prettyFileNames[mimetype]
        return _prettyFileNames[mimetype]

      # # try to find a group for this file
      # group = mimetype.split("/")[0] + "/example"
      # if _prettyFileNames[group]
      #   return _prettyFileNames[group]

      # default to "common file"
      return mimetype.split("/")[1]

    ###*
     * find which file view template that should be used
     * @param  string   mimetype  the mime type
     * @return string             template name, or null if not found
    ###
    viewTemplate: (mimetype) ->
      # return template function name if there is any
      if _templateNames[mimetype] then _templateNames[mimetype] else 'noTemplate'
  }
]
