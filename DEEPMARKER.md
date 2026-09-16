# DeepMarker fork of ocaml-opentelemetry

Fork of <https://github.com/imandra-ai/ocaml-opentelemetry>, branched at
**v0.91.1**, commit `3b403aafd3732c59d72111bde8a39de86797ce45`.

Consumed as a submodule at `ocaml/vendors/ocaml-otel` in the `dm` monorepo,
where `dune`'s `vendored_dirs` builds it in tree. The Async OTLP exporter built
on top of it is *not* here -- it lives in the monorepo at
`ocaml/src/lib/otel_async`, because its HTTP transport is httpun and its
concurrency is Async, neither of which upstream should have to care about.

## Why this fork exists

### 1. `?event_name` on log records — upstreamable, and should be offered

`src/proto/logs.ml` already carries OTLP's `event_name` field, but no API
reached it, so a named event could only be emitted as an anonymous log record
with its name lost. Added:

- `?event_name` on `Log_record.make`, `make_str` and `make_strf`;
- `Log_provider.event`, which emits a named event with a structured body;
- its `Logger.event` re-export.

This is a small, self-contained addition with no behaviour change for existing
callers. **It is worth sending upstream**; the rest of this fork is not.

### 2. Build filters for the monorepo — not upstreamable

`(dirs ...)` stanzas in `dune` and `src/dune` restrict the in-tree build to
the directories DeepMarker uses. The curl backend is not built: FHV2 is Async.
Restore a directory if its dependencies land in the switch.

### 3. `opentelemetry-client-ocurl.opam` deleted — not upstreamable

The monorepo's `make deps` installs the dependencies of every `*.opam` under
`vendors/`, and that one pulls `conf-libcurl` for a backend we do not build.

### 4. lwt and eio backends deleted — not upstreamable

DeepMarker is Async-only, so `opentelemetry-lwt`, `opentelemetry-cohttp-lwt`,
`opentelemetry-client-cohttp-lwt`, `opentelemetry-client-ocurl-lwt` and
`opentelemetry-client-cohttp-eio` are removed with their sources, tests
(`tests/client_e2e`, `tests/logs`, `tests/cohttp`, `tests/ocurl-lwt`) and CI
entries. Expect conflicts in those paths on rebase: resolve by keeping them
deleted.

## Syncing with upstream

```sh
git remote add upstream https://github.com/imandra-ai/ocaml-opentelemetry.git
git fetch upstream
git rebase upstream/main      # keep the patches above on top
```

Check afterwards that `Log_record.make` still takes `?event_name`: if upstream
has added it, patch 1 can be dropped.
