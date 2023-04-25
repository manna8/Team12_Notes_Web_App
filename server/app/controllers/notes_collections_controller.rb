class NotesCollectionsController < ApplicationController
  #before_action :set_notes_collection, only: [ :show, :update, :destroy, :check_if_admin_or_owner ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:all_collections]

  before_action :check_if_admin_or_owner, only: [:shared_users, :show, :update, :sharing_update, :destroy]
  # GET /notes_collections
  # GET /notes_collections.json
  def index
    if @is_admin
      render_all_collections
    else
      @notes_collections = NotesCollection.where(:user_id => @current_user[:id])
      render json: @notes_collections
    end
  end
  def render_all_collections
    @notes_collections = NotesCollection.all
    render json:@notes_collections
  end
  def my_shared_collections
    collections = NotesCollection.where(user_id: @current_user[:id]).where.not(shared_with: [])
    render json: collections
  end

  def shared_with_me_collections
    collections = NotesCollection.where(:shared_with.in => [@current_user[:id]])
    render json: collections
  end


  def shared_users
    collection = NotesCollection.find(params[:id])

    users_ids  = collection.shared_with

    users_shared = users_ids.map{|id| {name: "", id: id } }
    users_shared.each do |shared|
      user = User.find_by(id: shared[:id])
      shared[:name] = user.name
    end
    render json: users_shared
  end

  # GET /notes_collections/1
  # GET /notes_collections/1.json
  def show
    # if @notes_collection[:user_id] == @current_user[:id] or @is_admin
      @notes = Note.where(:notes_collection_id => params[:id])
      render json:{ notes_collection: @notes_collection, notes: @notes }
    # else
    #   render json: { error: 'Not authorized' }, status: :unauthorized
    # end
  end

  # POST /notes_collections
  # POST /notes_collections.json
  def create
    @notes_collection = NotesCollection.new(notes_collection_params)

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
      render json: { errors: @notes_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_for_user
    @notes_collection = NotesCollection.new(notes_collection_params)

    @notes_collection.user = User.find_by(:id => params[:id])
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
      render json: { errors: @notes_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes_collections/1
  # PATCH/PUT /notes_collections/1.json
  def update
    if @notes_collection.update(notes_collection_params)
      render json: { message: 'Notes collection updated successfully.'}, status: :ok
    else
      render json: { errors: @notes_collection.errors.full_messages}, status: :unprocessable_entity
    end
  end


  def sharing_update
    notes_collection = NotesCollection.find(params[:id])
    if notes_collection.update(shared_with: params[:shared_with].map { |id| BSON::ObjectId.from_string(id) })
      render json: { message: 'Sharing updated successfully.'}, status: :ok
    else
      render json: { errors: notes_collection.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # DELETE /notes_collections/1
  # DELETE /notes_collections/1.json
  def destroy
    if @notes_collection.destroy
      render json: { message: 'Collection deleted successfully.' }, status: :ok
    else
      render json: { errors: @notes_collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

    def set_notes_collection
      @notes_collection = NotesCollection.find(params[:id])
    end


    def notes_collection_params
      params.require(:notes_collection).permit(:title, :description,  note_ids: [])
    end


  def check_if_admin_or_owner
    @notes_collection = NotesCollection.find(params[:id])
    unless @notes_collection[:user_id] == @current_user[:id] or @is_admin
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
