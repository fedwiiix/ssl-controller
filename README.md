# Ssl-controller

This script allow to check ssl connections in own websites and send sms if they don't have ssl

``` sh
# Execut script all days at 4 o'clocks

# add this in crontab - $ crontab -e
0 4 * * * /var/www/ssl-controller/ssl-controller.sh
```
