PREFIX ?= $(CURDIR)/build/bin/

CMD=nix-snapshotter

.PHONY: all build nix-snapshotter start-containerd start-nix-snapshotter run-hello run-redis clean set-crictl-config

all: build

build: $(CMD)

FORCE:

nix-snapshotter: FORCE
	go build -o $(PREFIX) .

build/containerd/config.toml:
	bash ./script/rootless/create-containerd-config.sh

build/nerdctl/nerdctl.toml:
	bash ./script/rootless/create-nerdctl-config.sh

build/nerdctl/nix-snapshotter.toml:
	bash ./script/rootless/create-nix-snapshotter-config.sh

start-containerd: build/containerd/config.toml
	bash ./script/rootless/containerd.sh

start-nix-snapshotter: nix-snapshotter build/nerdctl/nix-snapshotter.toml
	bash ./script/rootless/nix-snapshotter.sh

run-hello: build/nerdctl/nerdctl.toml
	bash ./script/rootless/nerdctl.sh run --rm docker.io/hinshun/hello:nix

run-redis: build/nerdctl/nerdctl.toml
	bash ./script/rootless/nerdctl.sh run --rm -p 6379:6379 docker.io/hinshun/redis:nix --protected-mode no

# e.g. `make nerdctl ARGS="--help"`
nerdctl:
	bash ./script/rootless/nerdctl.sh $(ARGS)

clean:
	rm -rf ./build
