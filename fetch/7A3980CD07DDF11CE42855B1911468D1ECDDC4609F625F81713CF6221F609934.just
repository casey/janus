elb_path = "s3://onespot-inbox-production/var/log/inbox_server/elb/AWSLogs/457442207269/elasticloadbalancing/us-east-1"
yesterday = `gdate --date yesterday +'%Y/%m/%d'`
source_dir = `pwd`

@info:
    echo {{source_dir}}
    echo {{elb_path}}/{{yesterday}}

start-es:
    docker-compose -f {{source_dir}}/es.yml up -d

stop-es:
    docker-compose -f {{source_dir}}/es.yml down

logs-es:
    docker-compose -f {{source_dir}}/es.yml logs -f

run-logstash-elb: start-es   
    docker run --rm -it --name logstash-elb\
    -e log.level=info\
    -v {{source_dir}}/logstash-pipeline/:/usr/share/logstash/pipeline/\
    -v ~/.aws/:/usr/share/logstash/.aws/\
    -v {{source_dir}}/logstash-data:/usr/share/logstash/data\
    --network=supporting_default\
    docker.elastic.co/logstash/logstash-oss:6.6.1\
    sh -c "logstash-plugin install logstash-filter-prune ; /usr/local/bin/docker-entrypoint"

@aa:
     cat <(printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

# https://letsencrypt.org/docs/certificates-for-localhost/
gen-local-cert:
    printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth"\
    | openssl req -x509 -out ssl/localhost.crt -keyout ssl/localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' -extensions EXT \
    -config /dev/stdin
