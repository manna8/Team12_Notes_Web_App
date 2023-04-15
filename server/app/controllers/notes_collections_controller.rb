class NotesCollectionsController < ApplicationController
  before_action :set_notes_collection, only: %i[ show update destroy ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:all_collections]
  # GET /notes_collections
  # GET /notes_collections.json
  def index
    if @is_admin
      all_collections
    else
      @notes_collections = NotesCollection.where(:user_id => @current_user[:id])
      render json: @notes_collections
    end
  end

  def all_collections
    @notes_collections = NotesCollection.all
    render json:@notes_collections
  end
  # GET /notes_collections/1
  # GET /notes_collections/1.json
  def show
    if @notes_collection[:user_id] == @current_user[:id] or @is_admin
      render json:@notes_collection
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  # POST /notes_collections
  # POST /notes_collections.json
  def create
    @notes_collection = NotesCollection.new(notes_collection_params)
    puts User.find_by(:id => @current_user[:id])
    @notes_collection.user = User.find_by(:id => @current_user[:id])
    if @notes_collection.save
      if params[:note_ids].present?
        note_ids = params[:note_ids]
        notes = Note.where(id: note_ids)

        notes.each do |note|
          note.notes_collection = @notes_collection
          note.save
        end
      end
      render json: { message: 'Collection created successfully.' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
    #   render :show, status: :created, location: @notes_collection
    # else
    #   render json: @notes_collection.errors, status: :unprocessable_entity
    # end
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
    render json: { message: 'Collection deleted successfully.' }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notes_collection
      @notes_collection = NotesCollection.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notes_collection_params
      params.require(:notes_collection).permit(:title, :description,  note_ids: [])
    end
end
