class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  # def create
  #   bird = Bird.create(bird_params)
  #   if bird.valid?
  #     render json: bird, status: :accepted
  #   else
  #     render json: {errors: bird.errors}, status: :unprocessable_entity
  #   end
  # end

  #bird.errors is a serializable object with all the error messages from our model activerecord validations.
  def create
    bird = Bird.create!(bird_params) #The exclamation mark is a must after the create since it raises  the required active record exception
    render json: bird  
  end


  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  end

  # PATCH /birds/:id
  def update
    bird = find_bird
    bird.update!(bird_params)  #The update without the exclamation mark is does not raise ana exception but instead sends back the innvalid object.
    render json: bird
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    bird.destroy
    head :no_content
  end

  private

  def find_bird
    Bird.find(params[:id])
  end

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def render_not_found_response
    render json: { error: "Bird not found" }, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)  #Invalid is an instance of the raised exception.
    render json:{errors: invalid.record.errors}, status: :unprocessable_entity  #This json will be an errors object  pointing to a list of key value pairs where the keys are the invalid attributes and the values are the messages 
    #render json:{errors: invalid.record.errors.full_messages},  status: :unprocessable_entity - this one renders an object of the 'errors' as key and the all the messages for the failed attributes as the value in an array.
  end

end
