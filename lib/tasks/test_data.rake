
namespace :test_data do
  desc "create plenty of test users by number arg."
  task :create_dummy_users, [:count] => :environment do |task, args|
    args.with_defaults(count: "10")
    number = args[:count].to_i
    number.times do |i|
      User.quick_create_dummy_user(i)
    end
  end
end