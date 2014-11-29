class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie::ratings

    if session[:ratings].nil?
      @list_by = ''
      session[:sort] = @list_by
      @filter_by = @all_ratings
      session[:ratings] = Hash[@filter_by.collect { |key| [key, 1] }]
    else
      @list_by = params[:sort]
      @filter_by = params[:ratings]
      if @list_by.nil? && @filter_by.nil?
        flash.keep
        redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
      elsif @list_by.nil?
        session[:ratings] = @filter_by
        flash.keep
        redirect_to movies_path(:ratings => @filter_by, :sort => session[:sort])
      elsif @filter_by.nil?
        session[:sort] = @list_by
        flash.keep
        redirect_to movies_path(:ratings => session[:ratings], :sort => @list_by)
      else
        @filter_by = @filter_by.keys
      end
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
