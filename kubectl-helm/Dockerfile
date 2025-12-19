ARG GITHUB_REGISTRY

FROM ${GITHUB_REGISTRY}/ubuntu:latest

ARG ARCH
ARG KUBE_VERSION
ARG HELM_VERSION
ARG YQ_VERSION

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends gettext jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -L https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/${ARCH}/kubectl --output /usr/bin/kubectl && \
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH}.tar.gz | tar -xzO linux-${ARCH}/helm > /usr/bin/helm && \
    curl -L https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_${ARCH} --output /usr/bin/yq && \
    chmod +x /usr/bin/helm /usr/bin/kubectl /usr/bin/yq && \
    mkdir /config && \
    chmod g+rwx /config /root && \
    kubectl version --client && \
    helm version

USER everuser

RUN helm plugin install https://github.com/chartmuseum/helm-push
