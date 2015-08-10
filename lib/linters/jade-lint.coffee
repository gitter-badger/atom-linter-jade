module.exports = ['useJadeDashLint', (textEditor) ->
  if !jadeLinterInit
    jade           = allowUnsafeNewFunction -> require('jade')
    jadeLinter     = new (require('jade-lint'))
    jadeLinterInit = true

  filePath       = textEditor.getPath()
  jadeLintConfig = require('jade-lint/lib/config-file') # Don't like this, but there isn't a good
                                                        # interface at the moment
  jadeLinter.configure(jadeLintConfig.load(undefined, path.dirname(filePath)))

  return new Promise (resolve, reject) ->
    resolve (allowUnsafeEval -> allowUnsafeNewFunction ->
      jadeLinter.checkString(textEditor.getText(), filePath)).map(
        (err) ->
          {
            file     : err.filename
            code     : err.code
            line     : err.line
            column   : err.column || 0
            message  : err.msg
            sameFile : true
          }
    )
]
