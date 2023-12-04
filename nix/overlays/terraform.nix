final: prev:

let
  terraform = prev.mkTerraform {
    version = "1.3.9";
    hash = "sha256-gwuUdO9m4Q2tFRLSVTbcsclOq9jcbQU4JV9nIElTkQ4=";
    vendorHash = "sha256-CE6jNBvM0980+R0e5brK5lMrkad+91qTt9mp2h3NZyY=";
    patches = prev.terraform_1.patches;
    meta = prev.terraform_1.meta // {
      # The older version is released under MPL 2.0.
      license = prev.lib.licenses.mpl20;
    };
    passthru = {
      inherit (prev.terraform_1) plugins tests;
    };
  };
in
{
  inherit terraform;
  terraform_1 = terraform;
}
