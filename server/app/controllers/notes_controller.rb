class NotesController < ApplicationController
  before_action :set_note, only: [ :show, :update, :destroy ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:all_notes]
  # GET /notes
  # GET /notes.json
  def index
  # .where(:country => 'canada')
  #   @notes = Note.find(:all, :conditions => { :user_id => @current_user[:id] })
    if @is_admin
      all_notes
    else
      @notes = Note.where(:user_id => @current_user[:id])
      #@notes = Note.all
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
    note = Note.find(params[:id])

    users_ids  = note.shared_with

    users_shared = users_ids.map{|id| {name: "", id: id } }
    users_shared.each do |shared|
      user = User.find_by(id: shared[:id])
      users_shared[:name] = user.name
    end
    render json: users_shared
  end
  def show
    if @note[:user_id] == @current_user[:id] or @is_admin
    render json:@note
    else
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  def all_notes
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
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end

    end




  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    if @note.update(note_params)
      render json: { message: 'Note updated successfully.'}, status: :ok
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def sharing_update
    note = Note.find(params[:id])
    if note.update(shared_with: params[:shared_with])
      render json: { message: 'Sharing updated successfully.'}, status: :ok
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    render json: { message: 'Note deleted successfully.' }, status: :ok

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :description, :photo_url, :notes_collection_id)
    end
end
