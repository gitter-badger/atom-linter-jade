path = require('path')

{allowUnsafeEval, allowUnsafeNewFunction} = require 'loophole'

jade           = null
jadeLinter     = null
jadeLintConfig = null
jadeLinterInit = false

linters = []

# Jade-Lint
linters.push((textEditor) ->
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
)

# Standard Jade Library
linters.push((textEditor) ->
  thisFile = textEditor.getPath()

  return new Promise (resolve, reject) ->
    try
      allowUnsafeEval -> allowUnsafeNewFunction -> jade.compile(textEditor.getText(), {
        filename : thisFile,
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
        fileName = thisFile;
        lineNum  = fileLine[2];
        message  = fileLine[1];

      # ErrMessage (line:col)
      # js-compiler errors with non-relevant line/column info
      if !fileLine.length
        fileLine = /(.*?) \(\d+:\d+\)/.exec(errLines[0]) || []
        lineNum  = 0
        message  = fileLine[1]

      sameFile = thisFile == fileName

      resolve([{
        file     : fileName
        line     : +lineNum
        column   : 0
        message  : message
        sameFile : sameFile
      }])
)

flattenArray = (ary, levels=1) ->
  [1..levels].forEach(-> ary = [].concat.apply([], ary))
  ary


LinterJade =
  grammarScopes : ['source.jade']
  scope         : 'file'
  lintOnFly     : true

  lint: (textEditor) ->
    return new Promise (resolve, reject) ->
      Promise.all(linters.map((linterFn) -> linterFn(textEditor))).then(->
        # get a straight list of all errors
        errs = flattenArray(arguments, 2)

        # filter out duplicate errors since we're using two different linters.  First one wins
        errs = errs.filter((err, ix, errs) ->
          for i in [0...ix]
            if (errs[i].line == err.line) && (errs[i].file == err.file) && (errs[i].message = err.message)
              return false

          return true
        )

        # convert to appropriate format
        errs = errs.map((err) ->
          type     : 'Error'
          text     : err.message + (if err.code then ' (' + err.code + ')' else '')
          filePath : err.file
          range    : if err.line then [
                [err.line - 1, err.column]
              , [err.line - 1, err.column]
            ] else []
        )

        resolve(errs)
      )

  config: (key) ->
    atom.config.get "linter-jade.#{key}"

module.exports = LinterJade
