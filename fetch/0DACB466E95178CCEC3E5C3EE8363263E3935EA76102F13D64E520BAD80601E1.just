build:
    docker build . -t nnurphy/gauge \
        --build-arg js_runner_url=http://172.178.1.204:2015/gauge/gauge-js-offline-2.3.6.zip \
        --build-arg html_report_url=http://172.178.1.204:2015/gauge/html-report-4.0.8-linux.x86_64.zip \
        --build-arg json_report_url=http://172.178.1.204:2015/gauge/json-report-0.3.2-linux.x86_64.zip \
        --build-arg spectacle_report_url=http://172.178.1.204:2015/gauge/spectacle-0.1.3-linux.x86_64.zip \

