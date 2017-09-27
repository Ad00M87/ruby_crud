require 'curb'
require 'colorize'
require 'json'
require 'pry'

def starting_menu
  puts "==========================".colorize(:yellow)
  puts "What would you like to do?".colorize(:yellow)
  puts "==========================".colorize(:yellow)
  puts "1) List all users"
  puts "2) List a single user"
  puts "3) Create a new user"
  puts "4) Edit a user"
  puts "5) Destroy a user"
  puts "6) Exit"

  input = gets.strip.to_i

  case input
    when 1
      index
    when 2
      showUser
    when 3
      createUser
    when 4
      editUser
    when 5
      deleteUser
    when 6
      exit
    else
      puts "That is an invalid option please try again".colorize(:red)
      starting_menu
  end
end

def index
  users_response = Curl.get("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users")
  parsed = JSON.parse(users_response.body)

  parsed.each do |user|
    puts "ID: #{user['id']}"
    puts "#{user['first_name']} #{user['last_name']}"
    puts "Phone: #{user['phone_number']}"
  end

  starting_menu
end

def showUser
  puts "What is the id of the user you would like to view?"
  id = gets.strip.to_i
  users_response = Curl.get("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/#{id}")
  user = JSON.parse(users_response.body)

  if user['id']
    puts "ID: #{user['id']}".colorize(:blue)
    puts "#{user['first_name']} #{user['last_name']}".colorize(:blue)
    puts "Phone: #{user['phone_number']}".colorize(:blue)
  else
    puts "That is an invalid user id try again".colorize(:red)
    showUser
  end

  starting_menu
end

def createUser
  puts "What is the users first name?"
  first_name = gets.strip
  puts "What is the users last name?"
  last_name = gets.strip
  puts "What is the users telephone number?"
  phone_number = gets.strip

  users_response = Curl::Easy.http_post("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/",
    Curl::PostField.content('user[first_name]', "#{first_name}"),
    Curl::PostField.content('user[last_name]', "#{last_name}"),
    Curl::PostField.content('user[phone_number]', "#{phone_number}"))

  user = JSON.parse(users_response.body)

  puts "ID: #{user['id']}".colorize(:blue)
  puts "#{user['first_name']} #{user['last_name']}".colorize(:blue)
  puts "Phone: #{user['phone_number']}".colorize(:blue)

  starting_menu
end

def editUser
end

def deleteUser
  puts "What is the id of the user you would like to delete?"
  id = gets.strip.to_i

  users_response = Curl.delete("http://devpoint-ajax-example-server.herokuapp.com/api/v1/users/#{id}")

  puts "User ID: #{id} was deleted".colorize(:red)

  starting_menu
end

starting_menu
