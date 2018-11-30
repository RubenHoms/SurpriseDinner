# Surprise Dinner [![build status](https://gitlab.surprisedinner.nl/ruben/SurpriseDinner/badges/develop/build.svg)](https://gitlab.surprisedinner.nl/ruben/SurpriseDinner/commits/develop)
SurpriseDinner is an application that allows people to book, as the name already implies, surprise dinners. The idea behind it is to let people experience new restaurants and meals which they would in their comfort normally not choose.

## Setup instructions
In order to run this application you will need a few things.
1) RVM/rbenv to manage dependencies across different projects and install the correct ruby verison (set in .ruby-version)
2) Ruby
3) [A PostgreSQL installation](https://www.postgresql.org/download/)

Once you have those prerequisites installed it's time to get the application up and running.
* Run `bundle install` from within the cloned repository, this will install the gems needed to run the application.
* Copy `database.yml.sample` and `application.yml.sample` files into the same directory without the `.sample` extension.
* Edit the `database.yml` file with your connection details.
* Edit the `secrets.yml` and `application.yml` file with your own secrets.
* Run `rails server` to startup the server.

Your development server should now be up-and-running and you can view it at `http://lvm.me:3000`

Now... get working you lazy slacker!

## Workflow
If you start working on a new feature the first thing you do is start a new branch. The reason behind this is to keep the master branch squeaky clean.

Note that small changes, such as updating the README or obvious mistakes without potential side effects can be comitted to the master branch.

Once you're done writing the code and [tests](#testing) it's time to make a merge request. Go to the 'Merge request' section of the project in Gitlab and assign someone to review your code for you.

The reason behind merge requests is dual. The first reason is that by doing code reviews we have an easy way to spot mistakes or logical errors early on. On the other hand it promotes knowledge sharing, you might just know a more easy way to solve the problem at hand and can help the codebase that way.

After the merge request has been accepted and merged into the master branch the CI tool of GitLab will pick up the changes and deploy it to the staging environment.

## Testing<a name='testing'></a>
When writing Ruby on Rails code it's standard to start by writing tests (also called [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)). 
Although this is a workflow used by many developers, you should be able to write your tests after you write the code without any problems. 
As long as there are tests available for the piece of code you've written.

For more information on testing you can read up about [rspec](http://rspec.info/) and [factory-girl](https://github.com/thoughtbot/factory_girl)

## Deployment
The deployment is done with the help of [capistrano.](http://capistranorb.com/) The deployment tasks can be found in `config/deploy/<environment>.rb`.
To deploy changes made to the master branch to the [staging environment](https://staging.surprisedinner.nl) run `bundle exec cap staging deploy`.

## SSH Access
To access the servers through SSH your public SSH key needs to be added to the `~/.ssh/authorized_keys` file first. Ask one of the developers for access.
Once you have access you can access the servers with the following information:
* `ssh surprisedinner@gitlab.surprisedinner.nl`
* `ssh staging@staging.surprisedinner.nl`


## Mollie
You can set the Mollie API key by editing the `application.yml` file in the `/config` directory. The key used to get the Mollie API key is `MOLLIE_API_KEY`. There is a sample file located at `config/application.yml.sample` which you can use as a template.