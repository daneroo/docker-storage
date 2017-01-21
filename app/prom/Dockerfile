FROM prom/prometheus

ADD prometheus.yml /etc/prometheus/prometheus.yml

EXPOSE 9090

# trying to get debug to work to investigate discovery
# ENTRYPOINT [ "/bin/prometheus" ]
# CMD        [ "-log.level=debug" , \ 
#              "-config.file=/etc/prometheus/prometheus.yml", \
#              "-storage.local.path=/prometheus", \
#              "-web.console.libraries=/etc/prometheus/console_libraries", \
#              "-web.console.templates=/etc/prometheus/consoles" ]