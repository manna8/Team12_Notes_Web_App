class NotesCollectionsController < ApplicationController
  before_action :set_notes_collection, only: %i[ show update destroy ]

  # GET /notes_collections
  # GET /notes_collections.json
  def index
    @notes_collections = NotesCollection.all
  end

  # GET /notes_collections/1
  # GET /notes_collections/1.json
  def show
  end

  # POST /notes_collections
  # POST /notes_collections.json
  def create
    @notes_collection = NotesCollection.new(notes_collection_params)

    if @notes_collection.save
      render :show, status: :created, location: @notes_collection
    else
      render json: @notes_collection.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes_collections/1
  # PATCH/PUT /notes_collections/1.json
  def update
    if @notes_collection.update(notes_collection_params)
      render :show, status: :ok, location: @notes_collection
    else
      render json: @notes_collection.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes_collections/1
  # DELETE /notes_collections/1.json
  def destroy
    @notes_collection.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notes_collection
      @notes_collection = NotesCollection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notes_collection_params
      params.require(:notes_collection).permit(:title, :description)
    end
end
