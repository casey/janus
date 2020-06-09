alias b := build
alias d := doc
alias f := fix
alias l := lint
alias t := test
alias v := validate

# Ideally `build` would allow warnings - see https://github.com/rust-lang/cargo/issues/3591.
#
# Builds the project
build:
    cargo build

# For now, this is unused because it fails on GitHub runner (seems cargo thinks cargo-deny is not installed even though the binary has been included from cache)
#
# Installs everything needed for dependencies
_install_deps:
    cargo install --version 0.6.6 cargo-deny

# Installs everything needed for formatting
_install_format:
    rustup component add rustfmt

# Installs everything needed for linting
_install_lint:
    rustup component add clippy

# Generates documentation for public items
doc:
    cargo doc

# Generates documentation for public and private items
doc_all:
    cargo doc --document-private-items

# Fixes issues that can be addressed automatically
fix: _install_format fix_format

# Formats rust code
fix_format: _install_format
    cargo fmt

# Any lint that is not forbidden is explained below:
# DENY
# - elided_lifetimes_in_paths: allowed by Deserialize and Serialize
# - explicit_outlives_requirements: allowed by Deserialize and Serialize
# - redundant_semicolons: current issue with fehler
# - unreachable_code: allowed by fehler
# - unused_extern_crates: allowed by Deserialize and Serialize
# - unused_qualifications: allowed by Debug
# - unused_results: allowed by io::lsp::utils
# - unused_variables: allowed by thiserror
# - clippy::indexing_slicing: required by EnumMap
# - clippy::missing_inline_in_public_items: current issue with fehler
# - clippy::unreachable: required by Enum
# - clippy::useless_attribute: allowed by Serialize
# - clippy::missing_const_for_fn: positive on fn with match which is not stable
# - clippy::use_self: false positive on format macro
# - clippy::module_name_repetitions: okay for certain modules such as `error`
# ALLOW
# - box_pointers: box pointers are okay and useful
# - variant_size_differences: handled by clippy::large_enum_variant
# - clippy::multiple_crate_versions: not fixable when caused by dependencies
# - clippy::empty_enum: recommended `!` type is not stable
# - clippy::implicit_return: rust convention calls for implicit return
#
# Lints the project source code
lint: _install_lint
    cargo clippy --\
     -F absolute_paths_not_starting_with_crate\
     -F anonymous_parameters\
     -A box_pointers\
     -F deprecated_in_future\
     -D elided_lifetimes_in_paths\
     -D explicit_outlives_requirements\
     -F indirect_structural_match\
     -F keyword_idents\
     -F macro_use_extern_crate\
     -F meta_variable_misuse\
     -F missing_copy_implementations\
     -F missing_debug_implementations\
     -F missing_docs\
     -F missing_doc_code_examples\
     -F non_ascii_idents\
     -F private_doc_tests\
     -F single_use_lifetimes\
     -F trivial_casts\
     -F trivial_numeric_casts\
     -F unreachable_pub\
     -F unsafe_code\
     -D unused_extern_crates\
     -F unused_import_braces\
     -F unused_lifetimes\
     -D unused_qualifications\
     -D unused_results\
     -A variant_size_differences\
     -F warnings\
     -D redundant_semicolons\
     -D unreachable_code\
     -D unused_variables\
     -F ambiguous_associated_items\
     -F arithmetic_overflow\
     -F conflicting_repr_hints\
     -F const_err\
     -F ill_formed_attribute_input\
     -F invalid_type_param_default\
     -F macro_expanded_macro_exports_accessed_by_absolute_paths\
     -F missing_fragment_specifier\
     -F mutable_transmutes\
     -F no_mangle_const_items\
     -F order_dependent_trait_objects\
     -F overflowing_literals\
     -F patterns_in_fns_without_body\
     -F pub_use_of_private_extern_crate\
     -F soft_unstable\
     -F unconditional_panic\
     -F unknown_crate_types\
     -F clippy::correctness\
     -F clippy::restriction\
     -F clippy::style\
     -F clippy::pedantic\
     -F clippy::complexity\
     -F clippy::perf\
     -F clippy::cargo\
     -F clippy::nursery\
     -D clippy::missing_const_for_fn\
     -D clippy::useless_attribute\
     -A clippy::empty_enum\
     -A clippy::multiple_crate_versions\
     -A clippy::implicit_return\
     -D clippy::indexing_slicing\
     -D clippy::missing_inline_in_public_items\
     -D clippy::unreachable\
     -D clippy::use_self\
     -D clippy::module_name_repetitions

# Create pull request for resolving <issue_num>
pr issue_num:
    hub pull-request --push -m "`hub issue show -f "%t" {{issue_num}}`" -m "Closes #{{issue_num}}"

# Configures the version of rust
set_rust version:
    rustup override set {{version}}

# Runs tests
test:
    cargo test --verbose --all-features

# Validates the project
validate: (set_rust "1.43.0") validate_format validate_deps lint build test

# Validates dependencies of the project
validate_deps:
    cargo deny check

# Validates the formatting of the project
validate_format: _install_format
    cargo fmt -- --check
