{ config, pkgs, lib, gitignore, ... }:

{
  programs.git =
    let
      gi = gitignore.outPath;
      ignores = lib.lists.flatten (
        map
          (x: (lib.strings.splitString "\n"
            (lib.strings.fileContents x)))
          [
            (gi + "/Global/Linux.gitignore")
            (gi + "/Global/macOS.gitignore")
            (gi + "/Global/Emacs.gitignore")
            (gi + "/Global/Vim.gitignore")
          ]);
    in
    {
      inherit ignores;
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          email = "andre.abadesso@gmail.com";
          name = "André Abadesso";
        };
        alias = {
          log = "log --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset %s %C(green)(%an)%Creset%C(auto)%d%Creset' --date=short";
          show = "show --format='%C(yellow)%h%Creset %C(cyan)%ad%Creset %s %C(green)(%an)%Creset%C(auto)%d%Creset%n' --date=short";
          blame = "blame --date=short";
        };
        init = {
          defaultBranch = "master";
        };
      };
    };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
