# argparse

A moderately opinionated argument parser for
[janet](https://janet-lang.org). Use this for writing
CLI scripts that need to have UNIX style switches and
options.

## Sample

```clojure
#!/usr/bin/env janet

(import argparse :prefix "")

(def res
  (argparse
    "A simple CLI tool. An example to start showing the capabilities of argparse."
    "verbose" {:kind :flag
               :short "v"
               :help "Print debug information to stdout."}
    "key" {:kind :option
           :short "k"
           :help "An API key for getting stuff from a server."
           :required true}
    "thing" {:kind :option
             :help "Some option?"
             :default "123"}))

(unless res (os/exit 1))
(pp res)
```

## Installing

Assuming a working install of Janet and `jpm`, you can install with
`[sudo] jpm install https://github.com/janet-lang/argparse.git`, which
will install the latest from master.

## Usage

Run `(doc argparse/argparse)` after importing for more information.

## License

This module is licensed under the MIT/X11 License.
