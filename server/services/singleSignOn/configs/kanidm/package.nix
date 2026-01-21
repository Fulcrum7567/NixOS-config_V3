{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.singleSignOn.kanidm.customStyling;
  
  # 1. The Transformation Logic (Build-time helper)
  # This function takes a source image (png/jpg) and builds a valid Kanidm SVG from it.
  mkKanidmSvg = name: src: pkgs-default.runCommand "${name}.svg" {
    nativeBuildInputs = [ pkgs-default.python3 ];
  } ''
    # 1. Prepare source image
    # We copy the source to a fixed name so the script can find it easily
    cp ${src} ./input-image

    # 2. Create the Python script
    # We use python3 (standard in NixOS) to avoid 'nodePackages' missing errors.
    cat > embed.py <<'EOF'
    import sys, os, base64

    # Files passed as arguments
    svg_out = sys.argv[1]

    # Detect MIME type by reading the file magic bytes
    # This is more robust than file extensions in the nix store
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

    # Generate the SVG content
    # We construct the SVG manually here rather than parsing a blueprint file.
    # This prevents any XML parsing issues and keeps the script tiny.
    svg_content = f"""<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
      <image href="{data_uri}" x="0" y="0" width="64" height="64" preserveAspectRatio="xMidYMid meet"/>
    </svg>"""

    # Write output
    with open(svg_out, "w") as f:
        f.write(svg_content)
    EOF

    # 3. Run the transformation
    # We essentially generate the SVG from scratch using the python script
    python3 embed.py "$out"
  '';

in
{
  config = lib.mkIf cfg.enable {
    services.kanidm.package = lib.mkForce (config.server.services.singleSignOn.kanidm.basePackage.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        # Locate the UI directory
        UI_DIR=$(find $out -type d -name "*pkg" | head -n 1)
        
        if [ -n "$UI_DIR" ]; then
          echo "Injecting custom UI assets..."

          cp ${cfg.favicon} "$UI_DIR/img/favicon.png"
          
          
        else
          echo "WARNING: Could not find Kanidm UI directory to patch."
        fi
      '';
    }));
  };


          /*
          # 1. Inject the Logo
          # cp ${mkKanidmSvg "logo" cfg.logo} "$UI_DIR/img/logo.svg"
          
          # 2. Inject the Square Logo
          # cp ${mkKanidmSvg "logo-square" cfg.logoSquare} "$UI_DIR/img/logo-square.svg"
          
          # 3. Inject CSS (if provided)
          #${lib.optionalString (cfg.customCss != null) ''
          #  cp ${cfg.customCss} "$UI_DIR/style.css"
          ''}
          */

}