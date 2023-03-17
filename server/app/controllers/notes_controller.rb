class NotesController < ApplicationController
  before_action :set_note, only: %i[ show update destroy ]
  before_action :authenticate_user!

  # GET /notes
  # GET /notes.json
  def index
  # .where(:country => 'canada')
  #   @notes = Note.find(:all, :conditions => { :user_id => @current_user[:id] })
    @notes = Note.where(:user_id => @current_user[:id])
    #@notes = Note.all
    render json: @notes

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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :description,  :collection_id, :image)
    end
end
