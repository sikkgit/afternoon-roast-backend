# Afternoon Roast Backend 

[Video Demo](https://www.youtube.com/watch?v=nqb_-oCB6AM)

A Morning Brew-inspired simple content management system that allows writers to create stories, attach stories to a particular newsletter, and ultimately "publish" the newsletter to an API.

[Link to Frontend](https://github.com/vuonga1103/afternoon-roast-frontend)

## Getting Started

1. Install [Homebrew](https://brew.sh/)

    ```$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"```
  
2. Install [Ruby](https://www.ruby-lang.org/en/)
    
    ```$ brew install ruby```

3. Install [Rails](https://rubyonrails.org/)

    ```$ gem install rails```

4. Install [PostgreSQL](https://www.postgresql.org/)

    ```$ brew install postgresql```


## Downloading This Project

1. Clone the repo and cd into the folder
2. Bundle Install

    ```$ bundle install```
    
3. Create migrations, migrate and seed:

    ```
    $ rails db:create
    $ rails db:migrate
    ```
    
4. Obtain Lyra API key and include in `.env` in the following format:
```
export LYRA_API_KEY=<YOUR API KEY HERE>
```
5. Last step, launch the rails server!

    ```$ rails s -p 4000```
