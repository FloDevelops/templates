# INSTRUCTIONS

This script iterates through all BigQuery projects of the current user and its datasets starting by "analytics_", and tables starting by either "events_", "pseudonymous_users_" ou "users_".
Then if one of the matching datasets or tables has an expiritation date, this expiration is disabled.

To run the script, open Cloud Shell in your GCP project and run the following command:

```shell
curl -sSL https://raw.githubusercontent.com/FloDevelops/templates/main/remove_all_tables_expiration.sh | bash
```