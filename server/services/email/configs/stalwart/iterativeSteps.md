# Iterative steps I had to do during installation in case I need them again
- kanidm login -H "https://sso.aurek.eu" --name "admin" --password $(sudo cat /run/secrets/kanidm/adminPassword)
- kanidm service-account api-token generate stalwart-ldap "LDAP Bind Token" --name idm_admin --url "https://sso.aurek.eu"
- Set a UNIX-Password in the kanidm web ui
