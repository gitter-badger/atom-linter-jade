# linter-jade package

A linter that uses both the official jade compiler as well as
[jade-lint](https://github.com/benedfit/jade-lint) (jade-lint is a new project and isn't feature
complete yet, so the compiler catches some errors that it doesn't.  I plan to remove the compiler
whenever that's possible)

See the [jade-lint](https://github.com/benedfit/jade-lint) package for instructions as to which
options are available via a `.jade-lintrc` file.

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
