class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @list_by = params[:sort]
    @filter_by = params[:ratings]
    @all_ratings = Movie::ratings

    if @list_by == 'title'
       @movies = Movie.order :title
       @filter_by = @all_ratings
    elsif @list_by == 'date'
       @movies = Movie.order :release_date
       @filter_by = @all_ratings
    else
      unless @filter_by.nil?
        @filter_by = @filter_by.keys
        @movies = Movie.where(rating: @filter_by)
      else 
        @filter_by = @all_ratings
        @movies = Movie.all
      end
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
