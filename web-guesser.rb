require "sinatra"

enable :sessions
set :sessions, :expire_after => 1000

get "/" do
	session[:random_number] = session[:random_number] || rand(1..100)
	session[:bg_color] = session[:bg_color] || 255
	session[:guesses] = session[:guesses] || []
	session[:message] = session[:message] || "Guess your number" 
	@chances = session[:chances] = session[:chances] || 7
	erb :main 
end

put "/result" do
	# puts params[:current_number]
	# puts session[:random_number]
	if params[:current_number].to_i == session[:random_number].to_i
		@result_message = "You Win!"
		session[:bg_color] = 0
		set_new_session
	else
		session[:chances] = session[:chances].to_i - 1
		session[:guesses] << params[:current_number]

		if difference > 10
			session[:bg_color] = 175
			session[:message] = "Your guess is way too high"
		elsif difference < -10
			session[:bg_color] = 175
			session[:message] = "Your guess is way too low"
		elsif difference > 0 && difference < 10
			session[:bg_color] = 95
			session[:message] = "Your guess is close, but too high"
		else
			session[:bg_color] = 95
			session[:message] = "Your guess is close, but too low"
		end 

		if session[:chances].to_i == 0
			@result_message = "You Lose!"
			set_new_session
		else
			redirect '/'
		end
	end
end

def difference
	((params[:current_number].to_i - session[:random_number].to_i))
end

def set_new_session
	@random_number = session[:random_number].to_i
	session[:random_number] = rand(1..100)
	session[:chances] = 7
	session[:bg_color] = 255
	session[:guesses] = []
	session[:message] = "Guess your number"
	erb :result
end