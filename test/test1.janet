(import ../argparse :prefix "")

(def argparse-params
  ["A simple CLI tool. An example to start showing the capabilities of argparse."
   "verbose" {:kind :flag
              :short "v"
              :help "Print debug information to stdout."}
   "key" {:kind :option
          :short "k"
          :help "An API key for getting stuff from a server."
          :required true}
   "thing" {:kind :option
            :help "Some option?"
            :default "123"}])

(with-dyns [:args @["testcase.janet" "-k" "100"]]
  (def res (argparse ;argparse-params))
  (when (res "verbose") (error (string "bad verbose: " (res "verbose"))))
  (unless (= (res "key") "100") (error (string "bad key: " (res "key"))))
  (unless (= (res "thing") "123") (error (string "bad thing: " (res "thing")))))

(with-dyns [:args @["testcase.janet" "-k" "100" "-v" "--thing" "456"]]
  (def res (argparse ;argparse-params))
  (unless (res "verbose") (error (string "bad verbose: " (res "verbose"))))
  (unless (= (res "thing") "456") (error (string "bad thing: " (res "thing")))))

(with-dyns [:args @["testcase.janet" "-h"]]
  (print "test -h flag (help output below is a passing test) ...")
  (def res (argparse ;argparse-params)))
