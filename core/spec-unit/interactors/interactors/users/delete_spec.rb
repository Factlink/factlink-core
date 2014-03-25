require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/users/delete'

describe Interactors::Users::Delete do
  include PavlovSupport
  before do
    stub_classes 'User'
  end

  describe '#validate' do
    it 'raises when current_user_password is invalid' do
      wrong_password = 'qwerty'
      user = double(username: 'username')
      pavlov_options = {
        ability: double(:ability, can?: true ),
        current_user: user
      }

      user.stub(:valid_password?).with(wrong_password)
          .and_return(false)

      User.stub(:find).with(user.username).and_return(user)

      interactor = described_class.new username: user.username,
                                       current_user_password: wrong_password,
                                       pavlov_options: pavlov_options

      expect(interactor.valid?).to eq(false)
    end
  end

  describe '#call' do
    it 'it calls the delete+anonymize commands' do
      user = double(:user, id: 'a234', username: 'username')
      pavlov_options = {
          ability: double(can?: true),
          current_user: double(valid_password?: true)
      }

      User.stub(:find).with(user.username).and_return(user)

      interactor = described_class.new username: user.username,
                                       current_user_password: '',
                                       pavlov_options: pavlov_options

      Pavlov.should_receive(:command)
        .with(:'users/mark_as_deleted', user: user, pavlov_options: pavlov_options)
        .ordered

      Pavlov.should_receive(:command)
        .with(:'users/anonymize_user_model', user_id: user.id, pavlov_options: pavlov_options)
        .ordered

      interactor.call
    end
  end
end
