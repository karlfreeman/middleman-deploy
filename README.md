Middleman Delpoy -- Deploy a middleman built site over rsync.

===

## QUICK START

Be sure that `rsync` is installed.

### Step 1

    gem install middleman-deploy

### Step 2

    middleman init example-site
    cd example-site

### Step 3

Edit `Gemfile`, and add:

    gem "middleman-deploy"

Then run:

    bundle install

### Step 4

#### These settings are required.

Edit `config.ru`, and add:

    activate :deploy do |deploy|
      deploy.user = "tvaughan"
      deploy.host = "www.example.com"
      deploy.path = "/srv/www/site"
    end

Adjust these values accordingly.

### Step 4.1

#### These settings are optional.

To use a particular SSH port (default is `22`), add:

      deploy.port = 5309

To pass the `--delete` option to rsync (default is `false`), add:

      deploy.delete = true

### Step 5

    middleman build
    middleman deploy
