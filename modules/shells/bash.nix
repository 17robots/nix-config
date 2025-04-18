{config, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellOptions = [
      "checkwinsize"
      "nocaseglob"
      "histappend"
      "cdspell"
      "autocd"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    historySize = 50000000;
    historyFileSize = 50000000;
    historyControl = ["ignoredups"];
    historyIgnore = ["exit"];
  };
}

