# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    @all_ratings = Movie.all_ratings
    @movies = Movie.order(session[:sort_by])
    @ratings = session[:ratings]
    unless @ratings
      @ratings = Hash[@all_ratings.collect { |item| [item, ""] }]
    end
    @movies = @movies.select { |movie| @ratings.key?(movie.send(:rating)) }

  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end