# Cohorts Challenge
Given a list of users, and a list of user orders,
group the users into week-long cohorts according to their signup date.

## Dependencies
* Rails (v5.1.6)
* Bundler (run `bundle install`)
* Up and running Postgres database
* _users.csv_ file located at the root of the projects _public_ directory
* _orders.csv_ file located at the root of the projects _public_ directory

## How to run
* Currently, the following order of operations must be executed in a rails console. They may take up to 15 minutes to process in one session:
    ```ruby
   # imports all users from users.csv
    User.backfill
 
   # imports all orders from orders.csv
    Order.backfill
 
   # generates cohorts according depending on our users and orders
    Cohort.backfill

   # generates buckets that belong to individual cohorts
   # it takes a few minutes to run and could be optimized
    Bucket.backfill
    ```
* Afterwards, you can start up the applications rails server with `rails s`,
  and proceed to localhost:3000 to examine the cohorts data in an HTML page.
* By default, the presented cohorts data at the root URL will range from the latest data that we have to 8 weeks backwards. You can override this behavior by making a request to the cohorts controller's show action e.g.:
    ```ruby
    # look back 12 weeks instead of the default 8:
    localhost:3000/cohorts/12
    ```