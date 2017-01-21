#!/usr/bin/env  bash

# not using versions yet only :latest

# Use a variable to select registry (now using docker.io/daneroo implicitly)
REGISTRY=daneroo
IMAGES="generator grafana prom"
PFX=dksto

# image basename matches directory
for ima in ${IMAGES}; do
  IMAGENAME=${REGISTRY}/${PFX}_${ima}
  docker build -t ${IMAGENAME} ${ima}
  docker push ${IMAGENAME}
  echo Built and pushed : docker build -t ${IMAGENAME} ${ima}
done
echo Built and pushed: ${IMAGES}