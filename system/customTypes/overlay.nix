self: super: {
    # We are extending the `lib` attribute from nixpkgs.
    lib = super.lib.extend (selfLib: superLib: {
        # Add a new attribute `myTypes` to lib.
        customTypes = import ./customTypes.nix { lib = super.lib; };
    });
}
