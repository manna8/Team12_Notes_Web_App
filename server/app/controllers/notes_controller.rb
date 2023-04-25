class NotesController < ApplicationController
  #before_action :set_note, only: [ :show, :update, :destroy, :shared_users, :check_if_admin_or_owner ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:all_notes]

  before_action :check_if_admin_or_owner, only: [:show, :shared_users, :update, :sharing_update, :destroy]
  # GET /notes
  # GET /notes.json
  def index
    if @is_admin
      render_all_notes
    else
      @notes = Note.where(:user_id => @current_user[:id])
      render json: @notes
    end
  end


  def my_shared_notes
    notes = Note.where(user_id: @current_user[:id]).where.not(shared_with: [])
    render json: notes
  end

  def shared_with_me_notes
    notes = Note.where(:shared_with.in => [@current_user[:id]])
    render json: notes
  end


  def shared_users
    # if @note[:user_id] == @current_user[:id] or @is_admin
      note = Note.find(params[:id])

      users_ids  = note.shared_with

      users_shared = users_ids.map{|id| {name: "", id: id } }
      users_shared.each do |shared|
        user = User.find_by(id: shared[:id])
        shared[:name] = user.name
      end
        render json: users_shared
      # else
      #   render json: { error: 'Not authorized' }, status: :unauthorized
      #end

  end
  def show
    #if @note[:user_id] == @current_user[:id] or @is_admin
    render json:@note
    # else
    #   render json: { error: 'Not authorized' }, status: :unauthorized
    # end
  end

  def render_all_notes
    @notes = Note.all
    render json:@notes
  end
  # GET /notes/1
  # GET /notes/1.json
  # def show
  # end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)
    @note.user = User.find_by(:id => @current_user[:id])

    if @note.save
        render json: { message: 'Note created successfully.' }, status: :created
      else
        render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
      end

    end

  def create_note_for_user
    @note = Note.new(note_params)
    @note.user = User.find_by(:id => params[:id])

    if @note.save
      render json: { message: 'Note created successfully.' }, status: :created
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update

    if @note.update(note_params)
      render json: { message: 'Note updated successfully.'}, status: :ok
    else
      render json:{errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sharing_update
    note = Note.find(params[:id])

    if note.update(shared_with: params[:shared_with].map { |id| BSON::ObjectId.from_string(id) })
      render json: { message: 'Sharing updated successfully.'}, status: :ok
    else
      render json: { errors: note.errors.full_messages } , status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    if  @note.destroy
      render json: { message: 'Note deleted successfully.' }, status: :ok
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :description, :photo, :notes_collection_id)
    end

  def check_if_admin_or_owner
    @note = Note.find(params[:id])
    unless @note[:user_id] == @current_user[:id] or @is_admin
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end
end
