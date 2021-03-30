# Variables

laptop := "root@nixos-laptop.local"
fujitsu := "root@nixos-fujitsu.local"

# Commands

default: cloudflare hercules-caches hercules-join htpasswd wireguard restic

cloudflare:      (deploy "cloudflare.env" "/var/keys")
hercules-caches: (deploy "binary-caches.json" "/var/lib/hercules-ci-agent/secrets")
hercules-join:   (deploy "cluster-join-token.key" "/var/lib/hercules-ci-agent/secrets")
htpasswd:        (deploy "htpasswd" "/var/keys")
wireguard:       (deploy "vpn.conf" "/etc/wireguard")
restic:          (copy   "restic-passwd" "/var/keys")

deploy file target: (deploy_generic file target fujitsu)
copy   file target: (deploy_generic file target laptop)

@deploy_generic file target host:
	mkdir decrypted
	sops --decrypt "{{file}}" > "decrypted/{{file}}"
	rsync --progress --perms --chmod="+r" "decrypted/{{file}}" "{{host}}:{{target}}/{{file}}"
	rm -rf decrypted
