# linter-jade package

A jade linter that uses three linters (because at the moment they provide different errors and
warnings :/)

- the official jade compiler
- [jade-lint](https://github.com/benedfit/jade-lint) jade-lint is a new project and isn't feature
  complete yet, so the compiler catches some errors that it doesn't.  Options are configured via a
  `.jade-lintrc` file
- [jadelint](https://github.com/rrdelaney/jadelint) Same issue as above.  Options via a
  `.jadelintrc` file ([docs](http://ryandelaney.io/jadelint/))

The naming between the two linters isn't exactly helpful!  I plan to remove the compiler whenever
that is possible

## Installation
Linter package must be installed in order to use this plugin. If Linter is not installed, please
follow the instructions [here](https://github.com/AtomLinter/Linter).

### Plugin installation
```
$ apm install linter-jade
```

## Settings

None at the moment :/  File issues if you want new features ;)  If anyone has any ideas as to how to
properly "lint" jade, also let me know, as the default lexer/tokenizer just throw the first error
and it's not always useful output.
