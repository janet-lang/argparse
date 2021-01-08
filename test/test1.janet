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

(defmacro suppress-stdout [& body]
  ~(with-dyns [:out (,file/open (if (,os/stat "/dev/null") "/dev/null" "nul") :w)]
     ,;body))

(with-dyns [:args @["testcase.janet" "-k" "100"]]
  (def res (suppress-stdout (argparse ;argparse-params)))
  (when (res "debug") (error (string "bad debug: " (res "debug"))))
  (when (res "verbose") (error (string "bad verbose: " (res "verbose"))))
  (unless (= (res "key") "100") (error (string "bad key: " (res "key"))))
  (when (res "expr")
    (error (string "bad expr: " (string/join (res "expr") " "))))
  (unless (= (res "thing") "123") (error (string "bad thing: " (res "thing")))))

(with-dyns [:args @["testcase.janet" "-k" "100" "--thing"]]
  (def res (suppress-stdout (argparse ;argparse-params)))
  (when res (error "Option \"thing\" missing arg, but result is non-nil.")))

(with-dyns [:args @["testcase.janet" "-k" "100" "-e" "foo" "-e"]]
  (def res (suppress-stdout (argparse ;argparse-params)))
  (when res (error "Option \"expr\" missing arg, but result is non-nil.")))

(with-dyns [:args @["testcase.janet" "-k" "100" "-v" "--thing" "456" "-d" "-v"
                    "-e" "abc" "-vvv" "-e" "def"]]
  (def res (suppress-stdout (argparse ;argparse-params)))
  (unless (res "debug") (error (string "bad debug: " (res "debug"))))
  (unless (= (res "verbose") 5) (error (string "bad verbose: " (res "verbose"))))
  (unless (= (tuple ;(res "expr")) ["abc" "def"])
    (error (string "bad expr: " (string/join (res "expr") " "))))
  (unless (= (res "thing") "456") (error (string "bad thing: " (res "thing"))))
  (unless (= (tuple ;(res :order))
             ["key" "verbose" "thing" "debug" "verbose"
              "expr" "verbose" "verbose" "verbose" "expr"])
    (error (string "bad order: " (string/join (res :order) " ")))))

(let [out @""]
  (with-dyns [:args @["testcase.janet" "-h"]
              :out  out]
    (def res (argparse ;argparse-params))
    (when res (error "Option \"h\", but result is non-nil."))
    (def msg
      (string "usage: testcase.janet [option] ... \n\n"
              "A simple CLI tool. An example to show the capabilities of argparse.\n\n"
              " Required:\n"
              " -k, --key VALUE                             An API key for getting stuff from a server.\n\n"
              " Optional:\n"
              " -d, --debug                                 Set debug mode.\n"
              " -e, --expr VALUE                            Search for all patterns given.\n"
              " -h, --help                                  Show this help message.\n"
              "     --thing VALUE=123                       Some option?\n"
              " -v, --verbose                               Print debug information to stdout.\n\n"))
    (unless (not (= (string out) msg))
      (error (string "bad usage message:\n\n" out)))))

(with-dyns [:args @["testcase.janet" "server"]]
  (def res (suppress-stdout (argparse
                              "A simple CLI tool."
                              :default {:kind :option})))
  (unless (= (res :default) "server")
    (error (string "bad default " (res :default)))))

(with-dyns [:args @["testcase.janet" "server" "run"]]
  (def res (suppress-stdout (argparse
                              "A simple CLI tool."
                              :default {:kind :accumulate})))
  (unless (and (deep= (res :default) @["server" "run"]))
    (error (string "bad default " (res :default)))))

(with-dyns [:args @["testcase.janet" "-k" "100" "--fake"]]
  (def res (suppress-stdout (argparse ;argparse-params)))
  (when res (error "Option \"fake\" is not valid, but result is non-nil.")))

(with-dyns [:args @["testcase.janet" "-l" "100" "--" "echo" "-n" "ok"]]
  (if-let [{"length" len :default cmd-args}
           (suppress-stdout (argparse "A simple CLI tool"
                                      "length" {:kind :option
                                                :short "l"
                                                :help "key"}
                                      :default {:kind :accumulate}))]
    (do
      (unless (= len "100")
        (error "option was not parsed correctly in the presence of `--`."))
      (unless (= ["echo" "-n" "ok"] (tuple ;cmd-args))
        (error "unnamed arguments after `--` were not parsed correctly.")))
    (error "arguments were not parsed correctly in the presence of `--`.")))
