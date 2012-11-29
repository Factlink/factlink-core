require 'pavlov_helper'
require_relative '../../../../app/interactors/interactors/comments/set_opinion.rb'


describe Interactors::Comments::SetOpinion do
  it 'initializes correctly' do
    user = mock()
    interactor = Interactors::Comments::SetOpinion.new '1', 'believes', current_user: user
    interactor.should_not be_nil
  end

  it 'without current user gives an unauthorized exception' do
    expect { Interactors::Comments::SetOpinion.new '1', 'believes'}.
      to raise_error(Pavlov::AccessDenied, 'Unauthorized')
  end

  it 'with a invalid comment_id doesn''t validate' do
    expect { Interactors::Comments::SetOpinion.new 'g', 'believes'}.
      to raise_error(Pavlov::ValidationError, 'comment_id should be an hexadecimal string.')
  end

  it 'with a invalid opinion doesn''t validate' do
    expect { Interactors::Comments::SetOpinion.new '1', 'dunno'}.
      to raise_error(Pavlov::ValidationError, 'opinion should be on of these values: ["believes", "disbelieves", "doubts"].')
  end
end
