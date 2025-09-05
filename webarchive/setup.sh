docker compose up -d
docker compose run --remove-orphans archivebox config --set SAVE_ARCHIVE_DOT_ORG=False
docker compose run --remove-orphans archivebox config --set SAVE_FAVICON=False
docker compose run --remove-orphans archivebox config --set CHROME_BINARY=chromium-browser
docker compose run --remove-orphans archivebox config --set PUBLIC_INDEX=False
docker compose run --remove-orphans archivebox config --set PUBLIC_SNAPSHOTS=False
docker compose run --remove-orphans archivebox config --set PUBLIC_ADD_VIEW=False
echo ""
printf "\e[38;5;050m Enter KeyCloak email ser username!!!! \e[0m";
docker compose run --remove-orphans archivebox manage createsuperuser
docker compose up -d --remove-orphans --force-recreate