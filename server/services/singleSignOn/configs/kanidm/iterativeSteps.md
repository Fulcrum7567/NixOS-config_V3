# Resetting password / adding new user
- Add a new user entry to /system/options/serverOptions.nix
- Log in as idm_admin: `kanidm login -H "https://sso.aurek.eu" --name "idm_admin" --password $(sudo cat /run/secrets/kanidm/adminPassword)`
- Reset the password: `kanidm person credential create-reset-token <username> --name idm_admin --url "https://sso.aurek.eu"`
- Click on the generated link to set a new password