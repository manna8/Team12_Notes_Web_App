class NotesController < ApplicationController
  before_action :set_note, only: %i[ show update destroy ]
  before_action :authenticate_user!
  before_action :authorize_admin!, only:[:all_notes]
  # GET /notes
  # GET /notes.json
  def index
  # .where(:country => 'canada')
  #   @notes = Note.find(:all, :conditions => { :user_id => @current_user[:id] })
    @notes = Note.where(:user_id => @current_user[:id])
    #@notes = Note.all
    render json: @notes
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
    puts User.find_by(:id => @current_user[:id])
    @note.user = User.find_by(:id => @current_user[:id])
    if @note.save
        render json: { message: 'Note created successfully.' }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    # render :show, status: :created, location: @note
    #     else
    #       render json: @note.errors, status: :unprocessable_entity
    #     end
    end




  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    @note = Note.find(note_params[:id])
    if @note.update(note_params)
      render :show, status: :ok, location: @note
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
      params.require(:note).permit(:title, :description, :collection_id, :image)
    end
end
