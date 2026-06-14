# Conformance tests for clojure.tools.logging on jolt.
#
# Run from the logging library directory or from the jolt repo:
#   janet test/logging_test.janet

# Jolt's init expects to run from the jolt repo directory (relative source-paths
# like "jolt-core" and "src/jolt" resolve from there). Switch there first, then
# add the logging src to JOLT_PATH so the loader finds clojure.tools.logging.
(def jolt-dir (string (os/cwd) "/../jolt"))
(let [existing (or (os/getenv "JOLT_PATH") "")
      logging-src (string (os/cwd) "/src")]
  (os/setenv "JOLT_PATH"
             (if (empty? existing) logging-src (string logging-src ":" existing))))
(os/cd jolt-dir)

(use ../../jolt/test/support/harness)

(defspec "clojure.tools.logging"
  ["info returns nil"   "nil"  "(do (require '[clojure.tools.logging :as log]) (log/info \"hi\" 42))"]
  ["debug suppressed"   "nil"  "(do (require '[clojure.tools.logging :as log]) (log/debug \"x\"))"]
  ["debug skips args"   "0"    "(do (require '[clojure.tools.logging :as log]) (let [a (atom 0)] (log/debug (reset! a 9)) @a))"]
  ["enabled? info"      "true" "(do (require '[clojure.tools.logging :as log]) (log/enabled? :info))"]
  ["enabled? debug"     "false" "(do (require '[clojure.tools.logging :as log]) (log/enabled? :debug))"]
  ["spy returns value"  "3"    "(do (require '[clojure.tools.logging :as log]) (log/spy :info (+ 1 2)))"]
  ["impl factory name"  "\"jolt/stderr\""
   "(do (require '[clojure.tools.logging.impl :as impl]) (impl/name (impl/find-factory)))"]
  ["real lib *tx-agent-levels*" "#{:info :warn}"
   "(do (require '[clojure.tools.logging :as log]) log/*tx-agent-levels*)"]
  ["real lib log-capture! present" "true"
   "(do (require '[clojure.tools.logging :as log]) (fn? log/log-capture!))"]
  ["real lib spyf present" "true"
   "(do (require '[clojure.tools.logging :as log]) (boolean (resolve 'log/spyf)))"])
