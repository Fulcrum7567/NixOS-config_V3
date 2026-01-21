{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.singleSignOn.kanidm.customStyling;
  
  # 1. The Transformation Logic (Build-time helper)
  # This function takes a source image (png/jpg) and builds a valid Kanidm SVG from it.
  mkKanidmSvg = name: src: pkgs-default.runCommand "${name}.svg" {
    nativeBuildInputs = [ pkgs-default.python3 ];
  } ''
    cp ${src} ./input-image

    cat > embed.py <<'EOF'
    import sys, os, base64

    svg_out = sys.argv[1]

    mime = "application/octet-stream"
    with open("./input-image", "rb") as f:
        data = f.read()
        
        # Check magic bytes
        if data.startswith(b'\x89PNG'):
            mime = "image/png"
        elif data.startswith(b'\xff\xd8'):
            mime = "image/jpeg"
        elif data.startswith(b'GIF8'):
            mime = "image/gif"

    # Encode to Base64
    b64_data = base64.b64encode(data).decode('utf-8')
    data_uri = f"data:{mime};base64,{b64_data}"

    svg_content = f"""<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
      <image href="{data_uri}" x="0" y="0" width="64" height="64" preserveAspectRatio="xMidYMid meet"/>
    </svg>"""

    # Write output
    with open(svg_out, "w") as f:
        f.write(svg_content)
    EOF

    python3 embed.py "$out"
  '';

  customKanidmPackage = pkgs-default.symlinkJoin {
    name = "kanidm-customized";
    paths = [ config.server.services.singleSignOn.kanidm.basePackage ]; 
    buildInputs = [ pkgs-default.makeWrapper ];
    
    # FIX: Explicitly pass through the required flag from the original package
    passthru = {
      enableSecretProvisioning = config.server.services.singleSignOn.kanidm.basePackage.enableSecretProvisioning or false;
      # Pass through the version just in case other things need it
      version = config.server.services.singleSignOn.kanidm.basePackage.version or "custom";
    };

    postBuild = ''
      TARGET_PKG_DIR=$(find $out -type d -name "pkg" | head -n 1)

      if [ -z "$TARGET_PKG_DIR" ]; then
        echo "Error: Could not find Kanidm 'pkg' directory."
        exit 1
      fi

      echo "Un-symlinking UI directory at $TARGET_PKG_DIR..."

      ORIG_DIR=$(readlink -f "$TARGET_PKG_DIR")
      rm "$TARGET_PKG_DIR"
      cp -r "$ORIG_DIR" "$TARGET_PKG_DIR"
      
      echo "Injecting custom assets..."
      
      cp ${cfg.favicon} "$TARGET_PKG_DIR/img/favicon.svg"
    '';
  };

in
{
  config = lib.mkIf cfg.enable {
    services.kanidm.package = lib.mkForce customKanidmPackage;
  };


          /*
          rm "$TARGET_PKG_DIR/img/logo.svg"
      cp ${mkKanidmSvg "logo" cfg.logo} "$TARGET_PKG_DIR/img/logo.svg"

      rm "$TARGET_PKG_DIR/img/logo-square.svg"
      cp ${mkKanidmSvg "logo-square" cfg.logoSquare} "$TARGET_PKG_DIR/img/logo-square.svg"

      ${lib.optionalString (cfg.customCss != null) ''
        rm "$TARGET_PKG_DIR/style.css"
        cp ${cfg.customCss} "$TARGET_PKG_DIR/style.css"
      ''}
          */

}