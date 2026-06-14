# clojure.tools.logging for Jolt

[clojure.tools.logging](https://github.com/clojure/tools.logging) ported to
[Jolt](https://github.com/jolt-lang/jolt) — a Clojure-on-Janet runtime.

The `logging.clj`, `readable.clj`, and `test.clj` sources are verbatim from
upstream (EPL 1.0, Alex Taggart). The jolt-specific part is a native
`clojure.tools.logging.impl` shim that replaces the JVM's classpath-based
backend probing (SLF4J, Log4j, java.util.logging, etc.) with a stderr-based
`LoggerFactory`.

## Usage

Add this library as a `:local/root` dependency in your project's `deps.edn`:

```clojure
{:paths ["src"]
 :deps {org.clojure/tools.logging {:local/root "../logging"}}}
```

Jolt resolves git and `:local/root` deps only — Maven coordinates are ignored.

Then require and use:

```clojure
(require '[clojure.tools.logging :as log])

(log/info "Server started on port" 8080)
(log/warn "Disk usage at" 92 "%")
(log/error (Exception. "timeout") "Request failed")
```

## API

All standard `clojure.tools.logging` macros and functions work:

| macro/fn | description |
|----------|-------------|
| `trace`, `debug`, `info`, `warn`, `error`, `fatal` | level-specific macros using print-style args |
| `tracef`, `debugf`, `infof`, `warnf`, `errorf`, `fatalf` | level-specific macros using format-string args |
| `logp` | print-style args with readable (pr-str) wrapping |
| `logf` | format-string args with readable wrapping |
| `log` | lowest-level logging macro |
| `spy` | log a form and its result (returns the result) |
| `spyf` | log `(format fmt result)` (returns the result) |
| `enabled?` | check if a level is enabled |
| `log-capture!` / `log-uncapture!` | redirect System.out/err to the log |
| `with-logs` | bind `*out*` / `*err*` to log writers |

The `clojure.tools.logging.readable` namespace mirrors the above with `pr-str`
wrapping for non-string arguments.

### Log levels

The default stderr logger emits at `:info` and above. `:trace` and `:debug` are
suppressed by default. Bind or alter `*level*` in `clojure.tools.logging.impl`
to change the threshold:

```clojure
(require '[clojure.tools.logging.impl :as impl])
(alter-var-root #'impl/*level* (constantly :debug))
```

### Custom LoggerFactory

The library's extension point is `*logger-factory*` — bind or alter its root to
swap in a custom `LoggerFactory` implementation:

```clojure
(require '[clojure.tools.logging.impl :as impl])

(def custom-factory
  (reify impl/LoggerFactory
    (name [_] "my-factory")
    (get-logger [_ logger-ns]
      (reify impl/Logger
        (enabled? [_ _] true)
        (write! [_ level throwable message]
          (println level logger-ns message))))))

(alter-var-root #'clojure.tools.logging/*logger-factory*
                (constantly custom-factory))
```

## Running tests

From the jolt repo directory:

```bash
JOLT_PATH=../logging/src janet test/spec/host-interop-spec.janet
```

Or directly from this directory (requires jolt at `../jolt`):

```bash
janet test/logging_test.janet
```

## License

Copyright (c) Alex Taggart. Distributed under the Eclipse Public License 1.0.
See [LICENSE](LICENSE) for details.

See the [upstream repository](https://github.com/clojure/tools.logging) for the
original library and documentation.
