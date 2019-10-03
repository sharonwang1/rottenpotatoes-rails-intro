class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all.order(params[:sort])
    
    # reference: https://stackoverflow.com/questions/9658881/rails-select-unique-values-from-a-column
    
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    
    # @selected = @all_ratings
   
    # if params[:ratings]
    #   @selected = params[:ratings].keys
    # end
    
    if session[:selected_sort].nil?
      session[:selected_sort] = ""
    end
    
    if !params[:sort].nil?
      session[:selected_sort] = params[:sort] #remember the setting
    end

    print "\n\n\n" + 'index=>' + session[:selected_ratings].to_s + "\n"
    if !params[:ratings].nil? #stores session and set @movies
      print "\n in 1 \n"
      @selected = params[:ratings].keys
      @movies = Movie.where(rating: @selected).order(session[:selected_sort])
      session[:selected_ratings] = params[:ratings]
    elsif !session[:selected_ratings].nil? #if no ratings selected, then get ratings from session
      print "\n in 2 \n"
      @selected = session[:selected_ratings].keys
      @movies = Movie.where(rating: @selected).order(session[:selected_sort]) 
    else #no ratings and no sessions, just display all with sort in store
      print "\n in 3 \n"
      @selected = @all_ratings
      @movies = Movie.all.order(session[:selected_sort])
    end
    
    

    @selected.each do |rating|
      params[rating] = 1
    end

    # if params[:ratings]
    #   @movies = Movie.where(rating: @selected)
    # end
    
    if (params[:sort] == nil or params[:ratings] == nil) and !session[:selected_sort].nil? and !session[:selected_ratings].nil?
      flash.keep #persist all flash values
      redirect_to movies_path(:sort => session[:selected_sort], :ratings => session[:selected_ratings])
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
