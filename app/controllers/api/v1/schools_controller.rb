class Api::V1::SchoolsController < Api::V1::ApplicationController

  def index
    @schools = School.all
  end

  def show
    @school = School.find(Integer(params[:id]))
  end

end