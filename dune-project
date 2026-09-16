(lang dune 3.11)

(name opentelemetry)

(generate_opam_files true)

(source
 (github ocaml-tracing/ocaml-opentelemetry))

(version 0.91.1)

(implicit_transitive_deps false)

(authors "ocaml-tracing"
         "ELLIOTTCABLE <opam@ell.io>"
         "the imandra team")

(maintainers "ocaml-tracing")

(license MIT)

;(documentation https://url/to/documentation)

(package
 (name opentelemetry)
 (synopsis "Core library for instrumentation and serialization for https://opentelemetry.io")
 (depends
  (ocaml
   (>= "4.08"))
  ptime
  hmap
  (odoc :with-doc)
  (alcotest :with-test)
  (pbrt
   (and
    (>= 4.0)
    (< 5.0)))
  (pbrt_yojson
   (and
    (>= 4.0)
    (< 5.0)))
  (ambient-context
   (>= 0.2))
  (ocaml-lsp-server :with-dev-setup)
  (ocamlformat
   (and
    :with-dev-setup
    (>= 0.27)
    (< 0.28)))
  (mtime
   (>= "1.4")))
 (depopts atomic trace thread-local-storage picos)
 (conflicts
  (trace
   (< 0.12)))
 (tags
  (instrumentation tracing opentelemetry datadog jaeger)))

(package
 (name opentelemetry-client)
 (synopsis "Client SDK for https://opentelemetry.io")
 (depends
  (opentelemetry
   (= :version))
  (odoc :with-doc)
  (alcotest :with-test)
  (thread-local-storage
   (and
    (>= 0.2)
    (< 0.3))))
 (tags
  (tracing opentelemetry sdk)))

(package
 (name opentelemetry-client-ocurl)
 (depends
  (ocaml
   (>= "4.11"))
  (mtime
   (>= "1.4"))
  ; for spans
  ; atomic ; vendored
  (opentelemetry
   (= :version))
  (opentelemetry-client
   (= :version))
  (odoc :with-doc)
  (ezcurl
   (>= 0.2.3))
  curl
  (alcotest :with-test))
 (synopsis "Collector client for opentelemetry, using http + ezcurl"))

(package
 (name opentelemetry-logs)
 (depends
  (ocaml
   (>= "4.08"))
  (opentelemetry
   (= :version))
  (odoc :with-doc)
  (logs
   (>= "0.7.0"))
  (alcotest :with-test))
 (synopsis "Opentelemetry-based reporter for Logs"))

