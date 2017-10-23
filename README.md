# Rails Unfamiliar Environment

#### Objectives of an unfamiliar language

- Setup developer environments for applications written in unfamiliar languages.
- Analyze existing code in applications written in unfamiliar languages to fulfill requirements.

#### Your task:

- Setup Ruby/Rails environment
- Fix minor bugs (3):
  - There is a dependency missing.
  - The full stack curriculum seed is broken
  - Cohorts new button is broken.
  - Random pairs route gives an error.
- Add a feature

First set up [RVM/Rails](https://gist.github.com/berto/f4ac7d47d48c568490c8).
Then fork/clone this repo and follow the old instructions below to get it set up.

NOTE: The app uses an old version of Ruby. Also, you will need to add an OAuth
application to your github account in order to log in.

## coursework.galvanize.com

This is the Rails version of the LMS. It _used_ to be named students.galvanize.com, but is now coursework.galvanize.com.

### Development Environment

```sh
$ bundle
$ cp config/database.yml{.example,}
$ cp .env{.example,}
```

Setup an application on Github at https://github.com/settings/applications/new
and add the following settings:

* Application name: coursework.galvanize.com development
* Homepage URL: http://localhost:3000/
* Authorization callback URL: http://localhost:3000/auth/github/callback

Add the Client ID and Client Secret to `.env`.

NOTE: to log in as a student and an instructor locally, you'll need to create
two separate github accounts.  A good technique for this is to create a separate
Github account with a gmail + address (like user+testing@example.com).

```sh
$ rake db:create db:structure:load db:seed
```

### Setup git duet (optional)

Add a `.git-authors` file to your home directory.  See https://github.com/modcloth/git-duet for more info.

## Extra Seed Data

Check `lib/tasks/seed.rake` for other seed tasks you can perform, such as:

```sh
$ rake db:seed:full_stack_curriculum
```

## Testing

Run `rspec` to run all of the tests.

## Review Environment

[http://students-galvanize-review.herokuapp.com/](http://students-galvanize-review.herokuapp.com/)

Deployed automatically from [Semaphore](https://semaphoreci.com/galvanize-dev/students-galvanize-com)

## Javascript Challenges

The production url for the javascript challenges runs off of the STUDENT_CHALLENGES_URL variable.

- Production app lives at https://galvanize-student-challenges.herokuapp.com
- The git repo lives here: https://github.com/gSchool/student-challenges-app
- The Jasmine/Mocha formatters live here: https://github.com/gSchool/student-test-reporters
- The RSpec reporter lives here: https://github.com/gSchool/student-challenges-formatter-gem

## Troubleshoot

### Image Magick

If you run bundle and get the following:

`Can't install RMagick 0.0.0. Can't find Magick-config . . .`

You'll need to install the Image Magick dependency:

```sh
$ brew install imagemagick
```
