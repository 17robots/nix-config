{
  programs.git = {
    enable = true;
    extraConfig = {
      apply.whitespace = "fix";
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      commit.gpgsign = true;
      config.pull.rebase = true;
      core = {
        excludesfile = "~/.gitignore";
        attributesfile = "~/.gitattributes";
        whitespace = "space-before-tab, -indent-with-non-tab, trailing-space";
        trustctime = false;
      };
      diff.renames = "copies";
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      github.user = "17robots";
      gpg.format = "ssh";
      gpg.ssh.allowedsignersFiler = "";
      help.autocorrect = 1;
      init.defaultBranch = "main";
      merge.log = true;
      merge.stat = true;
      pull.ff = "only";
      pull.rebase = true;
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      url = {
        "git@github.com:github" = {
          insteadOf = [
            "https://githib.com/github"
            "github:github"
            "git://github.com/github"
          ];
        };
        "git@github.com:" = {
          pushInsteadOf = [
            "https://githib.com/"
            "github:"
            "git://github.com/"
          ];
        };
        "git://github.com/" = {
          insteadOf = "github:";
        };
        "git@gist.github.com:" = {
          insteadOf = "gst:";
          pushInsteadOf = [
            "gist:"
            "git://gist.github.com/"
          ];
        };
        "git://gist.github.com:" = {
          insteadOf = "gist:";
        };
      };
    };
    signing.signByDefault = true;
    userName = "17robots";
    userEmail = "mdray@duck.com";
  };
}
