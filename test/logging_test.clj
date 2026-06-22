(ns logging-test
  "clojure.tools.logging conformance on jolt-on-Chez."
  (:require [clojure.tools.logging :as log]
            [clojure.tools.logging.impl :as impl]))

(def failures (atom 0))
(defn check [label expected actual]
  (if (= expected actual)
    (println "  ok  " label)
    (do (swap! failures inc)
        (println "  FAIL" label "— expected" (pr-str expected) "got" (pr-str actual)))))

(defn -main [& _]
  (println "clojure.tools.logging")
  (check "info returns nil"   nil   (log/info "hi" 42))
  (check "debug suppressed"   nil   (log/debug "x"))
  (check "debug skips args"   0     (let [a (atom 0)] (log/debug (reset! a 9)) @a))
  (check "enabled? info"      true  (log/enabled? :info))
  (check "enabled? debug"     false (log/enabled? :debug))
  (check "spy returns value"  3     (log/spy :info (+ 1 2)))
  (check "impl factory name"  "jolt/stderr" (impl/name (impl/find-factory)))
  (check "*tx-agent-levels*"  #{:info :warn} log/*tx-agent-levels*)
  (check "log-capture! present" true (fn? log/log-capture!))
  (check "spyf present"       true  (boolean (resolve 'log/spyf)))
  (println (str "\n" (if (zero? @failures) "all passed" (str @failures " FAILED"))))
  (when (pos? @failures) (throw (ex-info "test failures" {:n @failures}))))
