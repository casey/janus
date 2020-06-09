build:
  cargo web deploy --release --output static/

serve:
  cargo web start --release --host 0.0.0.0
