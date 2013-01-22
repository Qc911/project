require 'faker'

namespace :db do#0
  desc "Peupler la base de donnees"
  task :populate => :environment do#1
    Rake::Task['db:reset'].invoke
    admin=User.create!(:nom => "Utilisateur exemple",
                 :email => "example@railstutorial.org",
                 :password => "foobar",
                 :password_confirmation => "foobar")
                 
   admin.toggle!(:admin)
    99.times do |n| #2
      nom  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "motdepasse"
      User.create!(:nom => nom,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    User.all(:limit => 6).each do |user| #3
      50.times do#4
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
         end#4
      end#3
    end#2
  end#1

