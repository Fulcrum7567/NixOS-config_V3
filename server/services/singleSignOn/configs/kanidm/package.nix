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
    passthru = (config.server.services.singleSignOn.kanidm.basePackage.passthru or {}) // {
      enableSecretProvisioning = config.server.services.singleSignOn.kanidm.basePackage.enableSecretProvisioning or false;
      # Pass through the version just in case other things need it
      version = config.server.services.singleSignOn.kanidm.basePackage.version or "custom";
      eolMessage = config.server.services.singleSignOn.kanidm.basePackage.eolMessage or "";
    };

    postBuild = ''
      # 1. FINDING THE SOURCE
      # We look for the 'hpkg' directory inside the ORIGINAL base package.
      # This guarantees we find the real source files.
      SOURCE_PKG_DIR=$(find ${cfg.basePackage} -type d -name "hpkg" | head -n 1)

      if [ -z "$SOURCE_PKG_DIR" ]; then
        echo "Error: Could not find 'hpkg' in base package."
        exit 1
      fi

      # 2. FINDING THE DESTINATION
      # We determine where that directory ended up in our new $out path.
      # We strip the base package prefix to get the relative path.
      REL_PATH=''${SOURCE_PKG_DIR#${cfg.basePackage}/}
      TARGET_PKG_DIR="$out/$REL_PATH"

      echo "Replacing UI directory..."
      echo "  Source: $SOURCE_PKG_DIR"
      echo "  Target: $TARGET_PKG_DIR"

      # 3. REPLACE WITH WRITABLE COPY
      # Remove the symlinked directory created by symlinkJoin
      rm -rf "$TARGET_PKG_DIR"
      
      # Copy the original directory contents to the target
      cp -r "$SOURCE_PKG_DIR" "$TARGET_PKG_DIR"
      
      # Make it writable (cp from Nix store is read-only by default)
      chmod -R +w "$TARGET_PKG_DIR"
      
      # 4. INJECT ASSETS
      echo "Injecting custom assets..."
      
      # We use -f to force overwrite just in case
      rm -f "$TARGET_PKG_DIR/img/favicon.png"
      cp ${cfg.favicon} "$TARGET_PKG_DIR/img/favicon.png"
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