# argparse

A moderately opinionated argument parser for
[janet](https://janet-lang.org). Use this for writing
CLI scripts that need to have UNIX style switches and
options.

## Sample

```clojure
#!/usr/bin/env janet

(import argparse :prefix "")

(def argparse-params
  ["A simple CLI tool. An example to show the capabilities of argparse."
   "debug" {:kind :flag
            :short "d"
            :help "Set debug mode."}
   "verbose" {:kind :multi
              :short "v"
              :help "Print debug information to stdout."}
   "key" {:kind :option
          :short "k"
          :help "An API key for getting stuff from a server."
          :required true}
   "expr" {:kind :accumulate
           :short "e"
           :help "Search for all patterns given."}
   "thing" {:kind :option
            :help "Some option?"
            :default "123"}])

(let [res (argparse ;argparse-params)]
  (unless res
    (os/exit 1))
  (pp res))
```

## Installing

Assuming a working install of Janet and `jpm`, you can install with
`[sudo] jpm install https://github.com/janet-lang/argparse.git`, which
will install the latest from master.

## Usage

Call `argparse/argparse` to attempt to parse the command line args
(available at `(dyn :args)`).

The first argument should be a description to be displayed as help
text.

All subsequent options should be alternating keys and values where the
keys are options to accept and the values are definitions of each option.

To accept positional arguments, include a definition for the special
value `:default`. For instance, to gather all positional arguments
into an array, include `:default {:kind :accumulate}` in your
arguments to `argparse`.

Run `(doc argparse/argparse)` after importing for more information.

## License

This module is licensed under the MIT/X11 License.
