let
  email = "benjaminvocaa@gmail.com";
  name = "benjamin-voca";
in
{
  programs = {
    git = {
      enable = true;
      extraConfig = {
        color.ui = true;
        core.editor = "hx";
        credential.helper = "store"; # Optional but not needed for SSH
        github.user = name;
        push.autoSetupRemote = true;
        rerere.enable = true;
        gpg.format = "ssh";
        user.signingKey = "~/.ssh/id_rsa.pub";
      };
      userEmail = email;
      userName = name;
    };
    gh = {
      enable = true;
      settings = {
        # alias = {
        #   # Set up convenient aliases for gh commands
        #   co = "repo clone";
        #   pr = "pr checkout";
        #   open = "repo view --web";
        # };
        # Configure default editor and repo visibility
        editor = "hx";
        prompt = true; # Avoid interactive prompts when possible !
        git_protocol = "ssh"; # Use SSH for all gh operations
        default_view = "list"; # Display issues/PRs in a list by default
      };
    };
    gh-dash = {
      enable = true;
    };
  };
}
