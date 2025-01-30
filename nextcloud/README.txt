Edit `config.php`:

Change:
```
'datadirectory' => '/data',
'overwriteprotocol' => 'https',
'overwrite.cli.url' => 'https://nextcloud.DOMAIN',
'loglevel' => 2,
```

Edit `nextcloud_apps/dav/lib/CalDAV/WebcalCaching/Plugin.php`
Change: ENABLE_FOR_CLIENTS to "/DAVx5.+/"

Edit `nextcloud_apps/dav/lib/CalDAV/CalendarHome.php`
Change: comment out if statement on line 186 (https://github.com/nextcloud/server/issues/42257#issuecomment-1857884065)

