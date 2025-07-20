FROM ubuntu:20.04

MAINTAINER tvm2360

RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y sudo apt-utils ca-certificates software-properties-common curl wget jq

RUN install -m 0755 -d /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update &&  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN curl -LO https://dl.k8s.io/release/v1.31.4/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/bin/kubectl

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod +x get_helm.sh && ./get_helm.sh && rm get_helm.sh

RUN wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && chmod +x /usr/local/bin/yq

RUN DEBIAN_FRONTEND=noninteractive && apt-get autoremove -y

RUN DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/cache/apt/archives/* && rm -rf /var/lib/apt/lists/*

CMD [ "bash", "-c", "echo" ]
