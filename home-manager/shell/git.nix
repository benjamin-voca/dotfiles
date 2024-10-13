let
  email = "benjaminvocaa@gmail.com";
  name = "benjamin-voca";
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "hx";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
    };
    userEmail = email;
    userName = name;
  };
}
