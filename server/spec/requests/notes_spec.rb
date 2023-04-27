require 'rails_helper'

RSpec.describe NotesController, type: :controller do

  let(:user) { create(:user, password: 'password') }
  let(:note) { create(:note, user: user) }
  let(:admin_user) { create(:user, role: 'admin', password:  'password') }
  let(:other_user) { create(:user, password:  'password') }

  before do
      old_controller = @controller
      @controller = SessionsController.new
      post :create, params: { email: user.email, password:  'password'}
      @controller = old_controller

  end

  describe 'GET #index' do
    context 'when user is not an admin' do
      it 'returns a list of notes belonging to the current user' do
        create_list(:note, 3, user: user)
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    context 'when user is an admin' do
      before do
        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: admin_user.email, password:  "password"}
        @controller = old_controller
      end

      it 'returns a list of all notes' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(Note.all.count)
      end
    end
  end

  describe 'GET #my_shared_notes' do
    it 'returns a list of notes shared by the current user' do
      shared_notes = create_list(:note, 3, user: user, shared_with: [other_user.id])
      unshared_note = create(:note)
      get :my_shared_notes
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
      expect(JSON.parse(response.body).to_ary).to match_array(shared_notes.as_json.to_ary)
    end
  end

  describe 'GET #shared_with_me_notes' do
    it 'returns a list of notes shared with the current user' do
      shared_notes = create_list(:note, 3, user: other_user, shared_with: [user.id])
      unshared_note = create(:note, user: other_user)
      get :shared_with_me_notes
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
      expect(JSON.parse(response.body).to_ary).to match_array(shared_notes.as_json.to_ary)
    end
  end

  describe 'GET #shared_users' do
    context 'when user is authorized' do
      it 'returns a list of users the note is shared with' do
        note.update(shared_with: [other_user.id])
        get :shared_users, params: { id: note.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body).first['id']["$oid"]).to eq(other_user.id.to_s)
      end
    end

    context 'when user is not authorized' do
      before do
        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: other_user.email, password:  'password'}
        @controller = old_controller
      end
      it 'returns an unauthorized error' do
        note.update(shared_with: [other_user.id])
        get :shared_users, params: { id: note.id }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Not authorized')
      end
    end
  end

      describe 'GET #show' do
        context 'when note belongs to the current user' do
          it 'returns the requested note' do
            get :show, params: { id: note.id }
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['title']).to eq(note.title)
          end
        end

        context 'when note does not belong to the current user' do
          it 'returns an error message' do
            note.update(user: other_user)
            get :show, params: { id: note.id }
            expect(response).to have_http_status(:unauthorized)
            expect(JSON.parse(response.body)['error']).to eq('Not authorized')
          end
        end

        context 'when the note does not exist' do
          it 'returns a 404 not found status code' do
            get :show, params: { id: 'invalid_id' }
            expect(response).to have_http_status(:not_found)
          end
        end
      end
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new note' do
        note_params = attributes_for(:note)
        expect {
          post :create, params: { note: note_params }
        }.to change(Note, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Note created successfully.')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error message' do
        note_params = attributes_for(:note, title: nil)
        post :create, params: { note: note_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Title can't be blank")
      end
    end
  end
  # describe 'POST #create_note_for_user' do
  #
  #   context 'when user is not an admin' do
  #
  #     it 'returns an error message and status 401' do
  #       post :create_note_for_user, params: { id: user.id, title: 'Test Note', content: 'This is a test note.' }
  #       expect(response).to have_http_status(:unauthorized)
  #       expect(JSON.parse(response.body)['error']).to eq('Not authorized')
  #     end
  #   end
  #
  #   context 'when user is not authenticated' do
  #     it 'returns an error message and status 401' do
  #       post :create_note_for_user, params: { id: user.id, title: 'Test Note', content: 'This is a test note.' }
  #       expect(response).to have_http_status(:unauthorized)
  #       expect(JSON.parse(response.body)['error']).to eq('You need to sign in or sign up before continuing.')
  #     end
  #   end
  #   context 'when user is an admin' do
  #     before do
  #       old_controller = @controller
  #       @controller = SessionsController.new
  #       post :create, params: { email: admin_user.email, password:  "password"}
  #       @controller = old_controller
  #     end
  #
  #
  #     it 'creates a note for the specified user' do
  #       post :create_note_for_user, params: { id: other_user.id, title: 'Test Note', content: 'This is a test note.' }
  #       expect(response).to have_http_status(:created)
  #       expect(Note.last.user).to eq(other_user)
  #       expect(Note.last.title).to eq('Test Note')
  #       expect(Note.last.content).to eq('This is a test note.')
  #     end
  #
  #     it 'returns an error if user is not found' do
  #       post :create_note_for_user, params: { id: 999, title: 'Test Note', content: 'This is a test note.' }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(JSON.parse(response.body)['errors']).to include('User must exist')
  #     end
  #   end


  # end
  describe 'POST #update' do
    context 'when the user is authorized to update the note' do
      it 'updates the note successfully' do

        post :update, params: { id: note.id, note: { title: 'New Title'} }
        expect(response).to have_http_status(:ok)
        expect(note.reload.title).to eq('New Title')

      end
    end

    context 'when the user is not authorized to update the note' do
      before do
        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: other_user.email, password:  'password'}
        @controller = old_controller

      end
      it 'returns unauthorized status' do
        patch :update, params: { id: note.id, note: { title: 'New Title form different user' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the user is authorized to delete the note' do
      let(:note) { create(:note, user: user) }
      it 'deletes the note successfully' do
        puts note.id
        expect {
          delete :destroy, params: { id: note.id}
        }.to change(Note, :count).by(-1)
        expect(response).to have_http_status(:ok)


      end
      end
    end

    context 'when the user is not authorized to delete the note' do
      before do
        old_controller = @controller
        @controller = SessionsController.new
        post :create, params: { email: other_user.email, password:  'password'}
        @controller = old_controller
      end
      it 'returns unauthorized status' do
        delete :destroy, params: { id: note.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
