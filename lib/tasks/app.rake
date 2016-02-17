namespace :app do

  desc "clean all unregistered user at midnight"
  task :clean_unregistered_users => :environment do
    User.unregistered.destroy_all
  end
end