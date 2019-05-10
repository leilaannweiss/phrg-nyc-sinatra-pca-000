# frozen_string_literal: true

class FiguresController < ApplicationController
  get "/figures/new" do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/new'
  end

  post "/figures" do # create action
    figure = Figure.new
    figure.name = params[:figure][:name]

    titles = Title.where(id: params[:figure][:title_ids])
    figure.titles = titles

    landmarks = Landmark.where(id: params[:figure][:landmark_ids])
    figure.landmarks = landmarks

    if params[:landmark][:name]
      figure.landmarks << Landmark.create(
        name: params[:landmark][:name],
        year_completed: params[:landmark][:year_completed]
      )
    end

    if params[:title][:name]
      figure.titles << Title.create(name: params[:title][:name])
    end

    figure.save
  end

  get "/figures" do
    @figures = Figure.all
    erb :'figures/index'
  end

  get "/figures/:id" do # view single figure
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  get "/figures/:id/edit" do # view form to edit single figure
    @figure = Figure.find(params[:id])
    erb :'figures/edit'
  end

  patch "/figures/:id" do # edit single figure
    @figure = Figure.find(params[:id])
    @figure.name = params[:figure][:name]
    @landmark = Landmark.new(name: params[:figure][:landmark])
    @figure.landmarks << @landmark
    @figure.save
    redirect to "/figures/#{@figure.id}"
  end
end
