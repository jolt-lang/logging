# clojure.tools.logging for jolt

A port of [org.clojure/tools.logging](https://github.com/clojure/tools.logging)
to jolt (Clojure on Chez Scheme). Same API — `info`/`warn`/`error`/`debug`,
`logf`/`logp`, `enabled?`, `spy`/`spyf`, `with-logs`, `log-capture!` — over a
default stderr backend that logs `:info` and above.

```clojure
(require '[clojure.tools.logging :as log])
(log/info "starting" {:port 3000})
(log/debug "suppressed by default")
```

Pull it from git in a `deps.edn`:

```clojure
{:deps {org.clojure/tools.logging
        {:git/url "https://github.com/jolt-lang/logging" :git/sha "..."}}}
```

## Test

```bash
joltc -M:test     # needs joltc (jolt-lang/jolt) on PATH
```
