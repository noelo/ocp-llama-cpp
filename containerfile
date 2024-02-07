FROM registry.access.redhat.com/ubi9/python-311

USER 0
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
RUN pip install llama-cpp-python

ENV MODELNAME=test
ENV MODELLOCATION=/tmp/models

## Set value to "--chat_format chatml" for prompt formats
## see https://github.com/abetlen/llama-cpp-python/blob/main/llama_cpp/llama_chat_format.py
ENV CHAT_FORMAT=""
EXPOSE 8080

ENTRYPOINT python3 -m llama_cpp.server --model ${MODELLOCATION}/${MODELNAME} ${CHAT_FORMAT} --host 0.0.0.0 --port 8080