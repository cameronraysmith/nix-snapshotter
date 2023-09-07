{ lib, inputs, ... }:
{
  perSystem = { pkgs, ... }: {
    packages = rec {
      # inherit (pkgs) nix-snapshotter;
      nix-snapshotter = inputs.nix-snapshotter.defaultPackage.${pkgs.system};
      default = nix-snapshotter;
    };

    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        containerd
        cri-tools
        delve
        gdb
        golangci-lint
        gopls
        gotools
        kind
        kubectl
        redis
        rootlesskit
        runc
        slirp4netns
        nerdctl
      ] ++ nix-snapshotter.nativeBuildInputs;
    };
  };
}
