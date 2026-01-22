{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.singleSignOn.kanidm.customStyling;
  cfgb = config.server.services.singleSignOn.kanidm;
  
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
      # 1. FIND SOURCE
      SOURCE_PKG_DIR=$(find ${cfgb.basePackage} -type d -name "hpkg" | head -n 1)
      if [ -z "$SOURCE_PKG_DIR" ]; then echo "Error: Could not find 'hpkg'"; exit 1; fi

      # 2. PREPARE TARGET
      REL_PATH=''${SOURCE_PKG_DIR#${cfgb.basePackage}/}
      TARGET_PKG_DIR="$out/$REL_PATH"
      
      # Remove the symlink and copy the real directory so we can edit it
      rm -rf "$TARGET_PKG_DIR"
      cp -r "$SOURCE_PKG_DIR" "$TARGET_PKG_DIR"
      chmod -R +w "$TARGET_PKG_DIR"
      
      echo "Injecting custom assets into $TARGET_PKG_DIR..."

      ${lib.optionalString (cfg.customCss != null) ''
        rm -f "$TARGET_PKG_DIR/style.css"
        cp -f ${cfg.customCss} "$TARGET_PKG_DIR/style.css"
      ''}
      

      # 4. INJECT FAVICON (PNG)
      ${lib.optionalString (cfg.favicon != null) ''
        rm -f "$TARGET_PKG_DIR/img/favicon.png"
        cp -f ${cfg.favicon} "$TARGET_PKG_DIR/img/favicon.png"
      ''}


      # 6. INJECT BACKGROUND IMAGE & CSS AUTO-FIX
      # We copy the image to the folder and APPEND the CSS rule to style.css
      # This ensures the path is correct (/pkg/img/background.jpg)
      ${lib.optionalString (cfg.backgroundImage != null) ''
        cp -f ${cfg.backgroundImage} "$TARGET_PKG_DIR/img/custom-background.jpg"
        
        # Append the CSS rule to load this specific image
        # Note: Kanidm maps this directory to /pkg/
        cat >> "$TARGET_PKG_DIR/style.css" <<EOF
        
        /* Auto-injected background from Nix */
        body {
          background-image: url("/pkg/img/custom-background.jpg") !important;
          background-size: cover !important;
          background-position: center !important;
        }
        EOF
      ''}
    '';
  };

in
{
  config = lib.mkIf cfg.enable {
    services.kanidm.package = lib.mkForce customKanidmPackage;

    systemd.services.kanidm.serviceConfig.BindReadOnlyPaths = [
      # Syntax: "Source:Destination"
      # We map the NEW UI directory (from custom package)
      # ON TOP OF the OLD UI directory (from base package)
      "${customKanidmPackage}/ui:${config.server.services.singleSignOn.kanidm.basePackage}/ui"
    ];
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