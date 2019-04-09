clean:
    vagrant ssh nomad-1 --command 'rm -rf /tmp/nomad'
    vagrant ssh nomad-2 --command 'rm -rf /tmp/nomad'

nomad-server:
    vagrant ssh nomad-1 --no-tty --command 'nomad agent -config /vagrant/nomad-server.hcl'

nomad-client idx:
    vagrant ssh nomad-{{idx}} --no-tty --command 'nomad agent -config /vagrant/nomad-client.hcl'

nomad-ui:
    open http://172.16.0.101:4646

consul-server:
    vagrant ssh nomad-1 --no-tty --command 'consul agent -config-file /vagrant/consul-server.hcl'

consul-client idx:
    vagrant ssh nomad-{{idx}} --no-tty --command 'consul agent -config-file /vagrant/consul-client.hcl'

consul-cluster idx:
    vagrant ssh nomad-{{idx}} --command 'consul join 172.16.0.101'
