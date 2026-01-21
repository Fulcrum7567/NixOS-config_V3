{ config, lib, pkgs-default, ... }:
let
  cfg = config.server.services.singleSignOn.kanidm.customStyling;
  
  # 1. The Transformation Logic (Build-time helper)
  # This function takes a source image (png/jpg) and builds a valid Kanidm SVG from it.
  mkKanidmSvg = name: src: pkgs-default.runCommand "${name}.svg" {
    nativeBuildInputs = [ pkgs-default.nodejs ];
    # We need JSDOM available to Node.js
    NODE_PATH = "${pkgs-default.nodePackages.jsdom}/lib/node_modules";
  } ''
    # Copy source so we can access it locally
    cp ${src} ./input-image

    # Create the Node.js script
    # We use 'EOF' (quoted) to stop bash from messing with variables
    cat > embed.js <<'EOF'
    const fs = require("fs").promises;
    const path = require("path");
    const { JSDOM } = require("jsdom");

    async function run(inputSvg, outputSvg) {
        try {
            const svgContent = await fs.readFile(inputSvg, "utf8");
            const dom = new JSDOM(svgContent, { contentType: "image/svg+xml" });
            const doc = dom.window.document;
            
            for (const img of doc.querySelectorAll("image")) {
                let href = img.getAttribute("href");
                if (href && !href.startsWith("data:")) {
                    const imgPath = path.resolve(path.dirname(inputSvg), href);
                    const imgData = await fs.readFile(imgPath);
                    const ext = path.extname(imgPath).toLowerCase();
                    const mime = ext === ".png" ? "image/png" : "image/jpeg";
                    const b64 = imgData.toString("base64");
                    
                    img.setAttribute("href", `data:''${mime};base64,''${b64}`);
                }
            }
            await fs.writeFile(outputSvg, dom.serialize());
        } catch (e) { console.error(e); process.exit(1); }
    }
    const args = process.argv.slice(2);
    run(args[0], args[1]);
    EOF

    # Create the blueprint SVG
    cat > blueprint.svg <<EOF
    <svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
      <image href="./input-image" x="0" y="0" width="64" height="64" preserveAspectRatio="xMidYMid meet"/>
    </svg>
    EOF

    # Run the transformation
    node embed.js blueprint.svg $out
  '';

in
{
  config = lib.mkIf cfg.enable {
    services.kanidm.package = lib.mkForce (cfg.basePackage.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
            # Locate the UI directory
            UI_DIR=$(find $out -type d -name "*pkg" | head -n 1)
            
            if [ -n "$UI_DIR" ]; then
              echo "Injecting custom UI assets..."

              cp ${cfg.favicon} "$UI_DIR/img/favicon.png"
              
              
              # 1. Inject the Logo
              # cp ${mkKanidmSvg "logo" cfg.logo} "$UI_DIR/img/logo.svg"
              
              # 2. Inject the Square Logo
              # cp ${mkKanidmSvg "logo-square" cfg.logoSquare} "$UI_DIR/img/logo-square.svg"
              
            else
              echo "WARNING: Could not find Kanidm UI directory to patch."
            fi
          '';
        });
      })
    ];
  };


              /*
              # 3. Inject CSS (if provided)
              #${lib.optionalString (cfg.customCss != null) ''
              #  cp ${cfg.customCss} "$UI_DIR/style.css"
              ''}
              */

}