{ pkgs, lib, ... }

custom_vim = pkgs.vim_configurable.customize customization;

vim = lib.overrideDerivation custom_vim (o: {
  gui = false;
  aclSupport = false;
  darwinSupport = false;
  hangulinputSupport = false;

  fontsetSupport = true;
  ftNixSupport = true;
  csopeSupport = true;
  pythonSupport = true;
  multibyteSupport = true
  luaSupport = true;
  mzschemeSupport = true;
  gpmSupport = true;
  });

in [
  vim
]
