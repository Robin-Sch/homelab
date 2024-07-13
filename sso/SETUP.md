Login using `admin:admin`, then make sure to change the default admin user.
Go to [Manage Users](https://sso.DOMAIN/admin/master/console/#/master/users), and click Add user.
Fill in details, set email verified.
Then go to the credentials tab and set the password.

First create a new realm (for example homelab), it's recommended to always create and use a new realm with reduced permissions instead of the master one.

Go to [Manage Users](https://sso.DOMAIN/admin/master/console/#/homelab/users), and click Add user.
Fill in details, set email verified.
Then go to the credentials tab and set the password.

Go to [Manage Clients](https://sso.DOMAIN/admin/master/console/#/homelab/clients), and click Create client.
1. Set Client ID and name to `oauth2-proxy`
2. Set client authentication on
3. Make sure only standard flow is enabled
4. Set root url to https://sso.DOMAIN and redirect url to /oauth2/callback
5. Save
Then go to the credentials tab and copy the secret to the `CLIENT_SECRET` env variable
Then go to client scopes, click `oauth2-proxy-dedicated`, configure a new mapper (type Audience).
1. Set name to `aud-mapper-oauth2-proxy`
2. Set Included client audience to `oauth2-proxy`
3. Enable ID token and access token
4. Save