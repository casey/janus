oec-example-1:
    cargo build --release --example oec_1 && time target/release/examples/oec_1 ../ps_calcs/data/year_origin_hs92_4.tsv --year 2017

oec-example-2:
    cargo build --release --example oec_2 && time target/release/examples/oec_2 ../ps_calcs/data/year_origin_hs92_4.tsv
