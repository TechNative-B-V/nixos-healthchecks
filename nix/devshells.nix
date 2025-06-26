{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      self',
      system,
      ...
    }:
    {
      # allow unfree packages
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      devShells = {
        default = pkgs.mkShell {
          packages = [
            self'.formatter.outPath
            pkgs.jetbrains.rust-rover
            pkgs.rustup
            pkgs.cargo-insta
            pkgs.python312Packages.playwright
            pkgs.playwright-test
            pkgs.chromium
          ];
          env = {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.libuuid ];
            PLAYWRIGHT_BROWSERS_PATH="${pkgs.playwright-driver.browsers}";
          };
        };
      };
    };
}
