# REIMAGINED-OCTO-HAPPINESS

## Building the toolbox

Run the following command to build the toolbox container: 

~~~bash
alias args='for var in `cat .env`; do out+="--build-arg ${var} "; done; echo ${out}; out=""'
docker build -t rails-toolbox -f Dockerfile.rails-toolbox $(args) .
~~~

## Initializing a new rails app

1. Mount the current directory as the `/opt/app` directory inside the container.
1. In the container, run the `rails new` command to set up the base structure for the app.

For example, to create a new rails app that is pre-configured for Postgresql backend database storage: 

`docker run -it -v $(pwd):/opt/app rails-toolbox rails new --skip-git --database=postgresql  --skip-bundle app`