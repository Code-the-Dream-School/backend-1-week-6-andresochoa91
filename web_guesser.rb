require "sinatra"

enable :sessions

get "/" do
	session[:random_number] = session[:random_number] || rand(1..100)
	session[:bg_color] = session[:bg_color] || 135
	@chances = session[:chances] = session[:chances] || 7
	erb :main 
end

put "/result" do
	puts params[:current_number]
	puts session[:random_number]
	if params[:current_number].to_i == session[:random_number].to_i
		@result_message = "You Win!"
		session[:bg_color] = 255
		set_new_session
	else
		session[:chances] = session[:chances].to_i - 1
		if ((params[:current_number].to_i - session[:random_number].to_i).abs) > 10
			session[:bg_color] = 175
		elsif ((params[:current_number].to_i - session[:random_number].to_i).abs) < 10
			session[:bg_color] = 95
		end 
		if session[:chances].to_i == 0
			@result_message = "You Lose!"
			set_new_session
		else
			redirect '/'
		end
	end
end

def set_new_session
	@random_number = session[:random_number].to_i
	session[:random_number] = rand(1..100)
	session[:chances] = 7
	session[:bg_color] = 135
	erb :result
end