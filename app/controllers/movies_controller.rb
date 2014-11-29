class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie::ratings
    @list_by = params[:sort]
    @filter_by = params[:ratings]

    if @filter_by.nil?
      @filter_by = session[:ratings].nil? ? @all_ratings : session[:ratings]
    else
      @filter_by = @filter_by.keys
      session[:ratings] = @filter_by
      @list_by = session[:sort] unless session[:sort].nil?
    end

    unless @list_by.nil?
      session[:sort] = @list_by
      @filter_by = session[:ratings] unless session[:ratings].nil?
    end

    if @list_by == 'title'
       @movies = Movie.where(rating: @filter_by).order :title
    elsif @list_by == 'date'
       @movies = Movie.where(rating: @filter_by).order :release_date
    else
        @movies = Movie.where(rating: @filter_by)
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
