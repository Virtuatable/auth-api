FROM cimg/ruby:3.0.0

copy . .

# Installs the mc binary to copy the frontend from the S3 of scaleway
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc && chmod +x ./mc
# Configure the mc binary to correctly copy data from scaleway
RUN ./mc alias set virtuatable ${BS_ENDPOINT} ${BS_ACCESS_KEY} ${BS_SECRET_KEY}
# Copies the content of the version we want to deploy currently
RUN ./mc cp --recursive virtuatable/auth-gui/${UI_VERSION} public/
# Installs dependencies to be able to start the server
RUN gem install bundler && bundle install

CMD ["bundle", "exec", "puma"]