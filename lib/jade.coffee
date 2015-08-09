LinterJadeProvider = require './linter-jade'

module.exports =
  activate: ->
    console.log 'activate linter-jade'

  provideLinter: -> LinterJadeProvider
