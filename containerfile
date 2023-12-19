FROM registry.access.redhat.com/ubi9:9.3-1476

#RUN subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
#RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN dnf install -y git make g++ atlas-devel atlas openblas openblas-openmp
#openblas-srpm-macros.noarch openblas-openmp flexiblas-netlib flexiblas flexiblas-openblas-openmp
RUN mkdir -p /opt/llama.cpp && chmod 777 /opt/llama.cpp

WORKDIR /opt

USER 1001
WORKDIR /opt
RUN git clone https://github.com/ggerganov/llama.cpp

WORKDIR /opt/llama.cpp
#RUN make LLAMA_OPENBLAS=1
RUN make

ENV MODELNAME=test
ENV MODELLOCATION=/tmp/models
ENV CONTEXTSIZE=512
## Set value to '--embedding' to enable embeddings
ENV EMBEDDINGS=""
EXPOSE 8080

ENTRYPOINT /opt/llama.cpp/server -m ${MODELLOCATION}/${MODELNAME} --embedding --ctx-size ${CONTEXTSIZE} ${EMBEDDINGS} --host 0.0.0.0