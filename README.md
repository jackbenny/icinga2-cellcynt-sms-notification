# Cellsynt SMS notification
These scripts sends out SMS notifictions for Icinga2 via the Swedish company
Cellsynt. There is one script for hosts, and one for services.

I have used the two scripts `mail-host-notification.sh` and `mail-service-notification.sh`
as templates for my scripts.

# Usage and installation
Drop the scripts `sms-host-notification.sh` and `sms-service-notification.sh` in */etc/icinga2/scripts/*.
Place `cellsyntuser.sh` in */etc/icinga2/* and set the username and password to match your account at
Cellsynt.

Next you need to define the commands in either *commands.conf* or by using Director. Below is an example of
my own *commands.conf* for host notifications.


```
object NotificationCommand "SMS Host Notification" {
    import "plugin-notification-command"
    command = [ "/etc/icinga2/scripts/sms-host-notification.sh" ]
    arguments += {
        "-4" = {
            required = true
            value = "$host.address$"
        }
        "-6" = {
            required = false
            value = "$host.address6$"
        }
        "-l" = {
            required = true
            value = "$host.name$"
        }
        "-o" = {
            required = true
            value = "$host.output$"
        }
        "-p" = {
            required = true
            value = "$user.pager$"
        }
        "-s" = {
            required = true
            value = "$host.state$"
        }
        "-t" = {
            required = true
            value = "$notification.type$"
        }
    }
}
```
