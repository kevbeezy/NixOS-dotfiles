{ pkgs, ... }:

let
  # Use the exact Lua version that pkgs.vis was compiled against
  visLua = pkgs.vis.lua or pkgs.lua;

  visLuaEnv = visLua.withPackages (
    lp: with lp; [
      lpeg
      luafilesystem
      dkjson
    ]
  );

  visWithLua = pkgs.symlinkJoin {
    name = "vis-with-lua-packages";
    paths = [ pkgs.vis ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/vis \
        --prefix LUA_PATH  ";" "${visLuaEnv}/share/lua/${visLua.luaversion}/?.lua;${visLuaEnv}/share/lua/${visLua.luaversion}/?/init.lua" \
        --prefix LUA_CPATH ";" "${visLuaEnv}/lib/lua/${visLua.luaversion}/?.so"
    '';
  };
in

{
  home.packages = with pkgs; [
    # Core editor & plugin dependencies
    visWithLua
    fzf
    fd
    git
    curl

    # LSP Servers
    clang-tools
    python3Packages.python-lsp-server
    lua-language-server
    bash-language-server
    nil

    # Formatters
    ruff
    stylua
    shfmt
    nixfmt
  ];

  xdg.configFile = {
    "vis/plugins/vis-modal".source = builtins.fetchGit {
      url = "https://git.symlinx.net/vis-modal";
      rev = "9c97d2455136ec9f9def295b850179fa76fee126";
    };
    "vis/plugins/vis-fzf-open".source = builtins.fetchGit {
      url = "https://codefloe.com/mcepl/vis-fzf-open.git";
      rev = "f0a8955e61acb934787588d8bec370306f0ab2e5";
    };
    "vis/plugins/goto-file".source = builtins.fetchGit {
      url = "https://repo.or.cz/vis-goto-file.git";
      ref = "master";
      rev = "6acb3f88f5adee326f45d7831e1e1048ff73b22d";
    };
    "vis/plugins/vis-command".source = builtins.fetchGit {
      url = "https://github.com/Nomarian/vis-command.git";
      rev = "898b47cf45d5f6eb1c94e5df89ebb24eb2ccf01c";
    };
    "vis/plugins/vis-autoclose".source = builtins.fetchGit {
      url = "https://codeberg.org/luxanna/vis-autoclose.git";
      rev = "b7657b363baf0b87a192d21deca0891a0c0378fe";
    };
    "vis/plugins/vis-jump".source = builtins.fetchGit {
      url = "https://codefloe.com/mcepl/vis-jump.git";
      rev = "07679f1332b5465b944570903b5fb932c4e7b5b2";
    };
    "vis/plugins/vis-lspc".source = builtins.fetchGit {
      url = "https://codeberg.org/muhq/vis-lspc.git";
      rev = "fadfe996f86b9fbb189255ae7fb7433519ba15f3";
    };
    "vis/plugins/vis-format".source = builtins.fetchGit {
      url = "https://github.com/milhnl/vis-format.git";
      rev = "1e37de7e9522383aa7bf769485767cfd0706c7e0";
    };
    "vis/plugins/vis-colorizer".source = builtins.fetchGit {
      url = "https://github.com/thimc/vis-colorizer.git";
      rev = "47e705e70edfacd4968b8038009caee3ef1eae3d";
    };
  };
}
