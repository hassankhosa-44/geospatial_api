# README

## Ticket Management System

This is a Ticket Management System application built with Ruby on Rails. It allows users to create, view, and manage tickets and associated excavator information.

## Features

* Create new tickets with relevant information such as request number, sequence number, request type, and request action.
* Associate each ticket with an excavator, including excavator company details, address, contact information, and crew on-site status.
* View a list of all tickets with their corresponding details.
* Syncing of tickets and excavator through API `api/sync`.
* Added maps through GoogleMaps Api which will show location of ticket.


## Requirements

* Ruby version 3.2.2
* Rails version 7.0.5
* PostgreSQL database

## Installation

* Clone the repository:
`git clone git@github.com:your-username/geospatial_api.git` 

* Navigate to the project directory:
`cd geospatial_api`

* Install the required dependencies:
`bundle install`

* Set up the database:
`rails db:create
rails db:migrate`

* Start the Rails server:
`rails server`

* Open your web browser and access the application at http://localhost:3000.


