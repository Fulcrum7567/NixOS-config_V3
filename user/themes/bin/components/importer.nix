let
  # Get the current directory (assuming importer.nix is run from this directory)
  dir = ./.;

  # Helper function to recursively find all .nix files in subdirectories
  getNixFiles = path:
    let
      entries = builtins.readDir path;
      paths = builtins.attrNames entries;
    in
      builtins.concatLists (map (name:
        let
          fullPath = "${path}/${name}";
          entryType = entries.${name};
        in
          if entryType == "directory" then
            getNixFiles fullPath
          else if entryType == "regular" && builtins.match ".*\\.nix" name != null then
            [ fullPath ]
          else
            []
      ) paths);

  nixFiles = getNixFiles dir;

  # Import each nix file
  imports = map import nixFiles;

in
imports
