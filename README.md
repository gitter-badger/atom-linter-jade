# linter-jade package

A very basic jade "linter" that just tries to compile the file and shows the first error.  But
it's better than nothing ;)  It should be noted that often the first error is a runtime error
resulting from the lack of a defined varaible, so in order to properly "lint" a file, you should set
undefined variables at the start of your file, e.g.:

```jade
- variable || (variable = [])
```

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
