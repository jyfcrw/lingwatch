every 1.day, :at => '3:00 am' do
  rake "app:clean_unregistered_users"
end

