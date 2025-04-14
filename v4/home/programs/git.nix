{
  programs.git = {
    enable = true;
    userName = "17robots";
    userEmail = "mdray@duck.com";
    signing = {
      key = "";
      signByDefault = true;
    };
    extraConfig = {
      github.user = "17robots";
      init.defaultBranch = "main";
      pull.rebase = true;
      apply.whitespace = "fix";
      core = {
        excludesfile = "~/.gitignore";
        attributesfile = "~/.gitattributes";
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";
        trustctime = false;
        editor = "nvim";
      };
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
      diff.renames = "copies";
      help.autocorrect = 1;
      merge.log = true;
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      url = {
        "git@github.com:github" = {
          insteadOf = [
            "https://github.com/github"
            "github:github"
            "git://github.com/github"
          ];
        };
        "git@github.com:" = {
          pushInsteadOf = [
            "https://github.com/"
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
        "git://gist.github.com/" = {
          insteadOf = "gist:";
        };
      };
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
  };
}
