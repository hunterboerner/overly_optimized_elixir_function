# BenchSortThing

**TODO: Add description**

Clone, install deps with `mix deps.get`, build the rust app with `cargo build
--release` (while in `rust_nif/`), move
`rust_nif/target/release/librust_nif.dylib` to
`rust_nif/target/release/librust_nif.so`. Run benchmarks with `mix bench`.

```
Settings:
  duration:      1.0 s

## ThingBench
[21:21:01] 1/12: true_droid single-iteration erl :lists (all occurrences of largest #)
[21:21:05] 2/12: true_droid single-iteration (all occurrences of largest #)
[21:21:08] 3/12: true_droid custom reduce
[21:21:10] 4/12: simple, but stupid... wow, not actually that bad. I'm surprised.
[21:21:12] 5/12: my second attempt using Enum.filter
[21:21:16] 6/12: my second attempt
[21:21:20] 7/12: my first attempt
[21:21:25] 8/12: kirillv
[21:21:27] 9/12: henrik single-iteration (broken...)
[21:21:30] 10/12: henrik second attempt (all occurrences of largest #)
[21:21:34] 11/12: count it
[21:21:38] 12/12: Rust NIF

Finished in 40.72 seconds

## ThingBench
Rust NIF                                                                  1000000   2.85 µs/op
true_droid custom reduce                                                   500000   3.41 µs/op
true_droid single-iteration (all occurrences of largest #)                 500000   5.99 µs/op
henrik second attempt (all occurrences of largest #)                       500000   6.39 µs/op
true_droid single-iteration erl :lists (all occurrences of largest #)      500000   6.42 µs/op
my second attempt using Enum.filter                                        500000   6.87 µs/op
my first attempt                                                           500000   6.88 µs/op
count it                                                                   500000   6.88 µs/op
my second attempt                                                          500000   6.89 µs/op
simple, but stupid... wow, not actually that bad. I'm surprised.           100000   14.38 µs/op
henrik single-iteration (broken...)                                        100000   23.52 µs/op
kirillv                                                                     50000   48.11 µs/op
```
