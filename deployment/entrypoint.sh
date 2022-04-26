function web {
  # Installs the mc binary to copy the frontend from the S3 of scaleway
  wget https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x ./mc
  # Configure the mc binary to correctly copy data from scaleway
  ./mc alias set virtuatable ${BS_ENDPOINT} ${BS_ACCESS_KEY} ${BS_SECRET_KEY}
  # Copies the content of the version we want to deploy currently
  ./mc cp --recursive virtuatable/auth-gui/${UI_VERSION} public/
  # Starts the application
  bundle exec puma
}

function shell {
  /bin/sh
}

case "$1" in
  "web")
  web
  ;;

  "shell")
  shell
  ;;