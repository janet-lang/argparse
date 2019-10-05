(import ../argparse :prefix "")

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

(with-dyns [:args @["testcase.janet" "-k" "100"]]
  (def res (argparse ;argparse-params))
  (when (res "debug") (error (string "bad debug: " (res "debug"))))
  (when (res "verbose") (error (string "bad verbose: " (res "verbose"))))
  (unless (= (res "key") "100") (error (string "bad key: " (res "key"))))
  (when (res "expr")
    (error (string "bad expr: " (string/join (res "expr") " "))))
  (unless (= (res "thing") "123") (error (string "bad thing: " (res "thing")))))

(with-dyns [:args @["testcase.janet" "-k" "100" "-v" "--thing" "456" "-d" "-v"
                    "-e" "abc" "-vvv" "-e" "def"]]
  (def res (argparse ;argparse-params))
  (unless (res "debug") (error (string "bad debug: " (res "debug"))))
  (unless (= (res "verbose") 5) (error (string "bad verbose: " (res "verbose"))))
  (unless (= (tuple ;(res "expr")) ["abc" "def"])
    (error (string "bad expr: " (string/join (res "expr") " "))))
  (unless (= (res "thing") "456") (error (string "bad thing: " (res "thing")))))

(with-dyns [:args @["testcase.janet" "-h"]]
  (print "test -h flag (help output below is a passing test) ...")
  (def res (argparse ;argparse-params)))

(with-dyns [:args @["testcase.janet" "server"]]
  (def res (argparse
             "A simple CLI tool."
             :default {:kind :option}))
  (unless (= (res :default) "server")
    (error (string "bad default " (res :default)))))

(with-dyns [:args @["testcase.janet" "server" "run"]]
  (def res (argparse
             "A simple CLI tool."
             :default {:kind :accumulate}))
  (unless (and (deep= (res :default) @["server" "run"]))
    (error (string "bad default " (res :default)))))

(with-dyns [:args @["testcase.janet" "-k" "100" "--fake"]]
  (print "test unknown flag (help output below is a passing test) ...")
  (def res (argparse ;argparse-params))
  (when res (error "Option \"fake\" is not valid, but result is non-nil.")))
