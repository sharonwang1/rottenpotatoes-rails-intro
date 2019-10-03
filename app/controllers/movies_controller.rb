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
    @movies = Movie.all.order(params[:sort])
    
    # reference: https://stackoverflow.com/questions/9658881/rails-select-unique-values-from-a-column
    
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    
    @selected = @all_ratings
   
    if params[:ratings]
      @selected = params[:ratings].keys
    end

    @selected.each do |rating|
      params[rating] = 1
    end

    if params[:ratings]
      @movies = Movie.where(rating: @selected)
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
