# README

An application that allows for the creation and management of schools, courses, batches, and students by
various user types including Admin, School Admin, and Student. With different user types and their respective
capabilities, the application offers a flexible and secure platform for educational organisations.



Ruby version : ruby 3.1.3p185

Rails version : 7.0.4

Database : Mysql

on setting up ruby and rails
run
  `bundle exec rake db:create`
  `bundle exec rake db:migrate`
to create and migrate database

run (admin creation is must)
  `rails db:seed`
to create admin user or
you can create your own admin from rails console
`user = User.create(first_name: "Admin", email: "admin@eschools.com", password: "password")
user.add_role(:admin)`


run `RAILS_ENV=development bundle exec rails assets:precompile
    bundle exec rails s`

    to start the app in dev mode

    open `http://localhost:3000/` in your browser and login with the admin credentials you cretaed either from seed or console

    Admin can create schools by navigating from tghe top nav bar

    School admin have to sign up first with the desired school they want to take controll off

    Admin has to make the user as school admin to give control to school admin

![admin/schools](https://github.com/anilyanduri/static-images/blob/main/school-admin.png)

    School admin can create courses and batches for the couses

    Student can sign up with there desired school and enroll for the availabe batches

![student enrolment](https://github.com/anilyanduri/static-images/blob/main/course-batches.png)

    School admins have to approve/reject the students request

![School admin to approve reject](https://github.com/anilyanduri/static-images/blob/main/approve-reject.png)

    students can study once approved also can see other students progress

![School batch view](https://github.com/anilyanduri/static-images/blob/main/student-batch.png)

