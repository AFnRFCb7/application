{
    inputs = { } ;
    outputs =
        {
            self
        } :
            {
                lib.implementation =
                    {
                        name ,
                        nixpkgs ,
                        package ,
                        system ,
                        text
                    } :
                        let
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                            in
                                pkgs.stdenv.mkDerivation
                                    {
                                        installPhase =
                                            let
                                                run =
                                                    pkgs.writeShellApplication
                                                        {
                                                            name = "run" ;
                                                            text =
                                                                ''
                                                                    nix run ${ package } --command "${ text }"
                                                                    nix-collect-garbage
                                                                '' ;
                                                        } ;
                                                in
                                                    ''
                                                        mkdir $out/bin
                                                        makeWrapper ${ run }/bin/run ${ name }
                                                    '' ;
                                        nativeBuildInputs = [ pkgs.coreutils pkgs.makeWrapper ] ;
                                    } ;
            }
}