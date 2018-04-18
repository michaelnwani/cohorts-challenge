# Cohorts Challenge

## Terminology
* **Signups**: The earliest occurrence of a user (according to primary key 'id') in the users table.
If the user doesn't exist in the users table, but exists in the orders table,
it's the earliest occurrence of the user id in the orders table (according to the 'created_at' column).
