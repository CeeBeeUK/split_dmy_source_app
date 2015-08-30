class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    respond_to do |format|
      if @person.save
        notice = 'Person was successfully created.'
        format.html { redirect_to @person, notice: notice }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        notice = 'Person was successfully updated.'
        format.html { redirect_to @person, notice: notice }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      notice = 'Person was successfully destroyed.'
      format.html { redirect_to people_url, notice: notice }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:date_of_birth)
  end
end
