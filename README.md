# uOttaHack6 - Backend

## Description

This repository contains the code for the backend of our project on sustainability. The backend is built using Node.js and Express.js. We are using a PostgreSQL database to store the data.

## Installation

1. Clone the repository
2. Run `npm install` to install the dependencies
3. Create a `.env` file in the root directory and add the following environment variables:
   - REACT_APP_URL="http://localhost:3000"
   - AUTH0_DOMAIN=""
   - AUTH0_CLIENT_ID=""
   - SOLACE_HOST=""
   - SOLACE_USERNAME=""
   - SOLACE_PASSWORD=""
   - SOLACE_CLIENT_ID=""
   - POSTGRES_USER=""
   - DATABASE=""
   - PASSWORD=""
   - HOST=""
4. Create a PostgreSQL database and add the database name, username, and password to the `.env` file
    - `psql -U postgres`
    - `CREATE DATABASE your_database_name;`
    - `\c your_database_name`
    - `CREATE USER your_username WITH PASSWORD 'your_password';`
    - `GRANT ALL PRIVILEGES ON DATABASE your_database_name TO your_username;`
5. Use the `ddl.sql` file found in `/db` to create the tables in the database and generate sample data
6. Run `npm run dev` to start the development server
