# Step 1.) Generate a new 2048 bit RSA key
key:
	openssl genrsa -out certs/key.pem 2048

# Step 2.) Generate a certificate request for the generated key
cert:
	openssl req -new -key certs/key.pem -out certs/key_req.csr

# Step 3.) Create a text configuration file for v3 certificate
v3:
	#!/usr/bin/bash
	cat > certs/v3.ext << EOL
	authorityKeyIdentifier=keyid,issuer
	basicConstraints=CA:FALSE
	keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
	EOL

# Step 4.) Generate a certificate (of the version v3)
gen_cert:
	openssl x509 -in certs/key_req.csr -out certs/cert.pem -req -signkey certs/key.pem -days 3650 -extfile certs/v3.ext

# Build & Run Serve
run:
	cargo watch -x run

