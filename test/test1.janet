(use ../argparse)

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

(with-dyns [:args @["janet" "somescript.janet" "-k" "100"]]
  (def res (argparse ;argparse-params))
  (unless (= (res "key") "100") (error "bad key"))
  (unless (= (res "thing") "123") (error "bad thing")))

(with-dyns [:args @["janet" "somescript.janet" "-h"]]
  (def res (argparse ;argparse-params)))
