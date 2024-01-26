{ ... }:
{
  config = {
    programs = {
      git = {
        delta.enable = true;
        enable = true;
        extraConfig = {
          branch.autosetupmerge = "true";
          commit.gpgsign = true;
          config.pull.rebase = false;
          core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
          delta.line-numbers = true;
          gpg.format = "ssh";
          gpg.ssh.allowedsignersfile = "";
          init.defaultBranch = "main";
          merge.stat = "true";
          pull.ff = "only";
          push.default = "current";
          rebase = {
            autoSquash = true;
            autoStash = true;
          };
          repack.usedeltabaseoffset = "true";
          rerere = {
            autoupdate = true;
            autoStash = true;
          };
        };
        signing = { 
          key = "~/.ssh/id_ed25519";
          signByDefault = true;
        };
        userName = "17robots";
        userEmail = "mdray@ameritech.net";
      };
    };
  };
}


