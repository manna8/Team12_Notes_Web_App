require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ensures username presence' do
    user = User.new(email: 'email', password: 'password').save
    expect(user).to  eq(false)
  end
  it 'ensures email presence' do
    user = User.new(name: 'username', password: 'password').save
    expect(user).to  eq(false)
  end
  it 'should save successfully' do
    user = User.new(name: 'username', email: 'email', password: 'password').save
    expect(user).to  eq(true)
  end


  #pending "add some examples to (or delete) #{__FILE__}"
end
