{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'
jade = allowUnsafeNewFunction -> require('jade')

LinterJade =
  grammarScopes : ['source.jade']
  scope         : 'file'
  lintOnFly     : true

  lint: (textEditor) ->
    return new Promise (resolve, reject) ->
      try
        result = allowUnsafeEval -> allowUnsafeNewFunction -> jade.compile(textEditor.getText(), {
          filename : textEditor.getPath(),
          doctype  : 'html'
        })

        resolve([])
      catch err
        errText  = err.message.trim()
        errLines = errText.split('\n') || []

        # file.jade:3
        fileLine = /(\S*\.jade):(\d+)/.exec(errLines[0]) || []
        fileName = fileLine[1]
        lineNum  = fileLine[2]
        message  = errLines[errLines.length - 1]

        # err on line 3
        if !fileLine.length
          fileLine = /(.*?) on line (\d+)$/.exec(errLines[0]) || []
          fileName = textEditor.getPath();
          lineNum  = fileLine[2];
          message  = fileLine[1];

        # ErrMessage (line:col)
        # js-compiler errors with non-relevant line/column info
        if !fileLine.length
          fileLine = /(.*?) \(\d+:\d+\)/.exec(errLines[0]) || []
          lineNum  = 0
          message  = fileLine[1]

        thisFile = textEditor.getPath()
        sameFile = thisFile == fileName

        message =
          type     : 'Error'
          text     : message
          filePath : textEditor.getPath()
          range    : if lineNum then [
                [lineNum - 1, -1]
              , [lineNum - 1, -1]
            ] else []

        resolve([message])

  config: (key) ->
    atom.config.get "linter-jade.#{key}"

module.exports = LinterJade
