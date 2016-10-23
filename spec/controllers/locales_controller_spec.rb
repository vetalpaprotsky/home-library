require 'rails_helper'

describe LocalesController do

  let(:user) { FactoryGirl.create(:user) }

  shared_examples 'get change_locale' do

    describe '#GET change_locale' do

      it 'redirects to root with new locale' do
        get :change_locale, language_abbr: 'ua'

        expect(response).to redirect_to root_path(locale: 'ua')
      end
    end
  end

  context 'SIGNED OUT' do

    include_examples 'get change_locale'
  end

  context 'SIGNED IN' do

    before { sign_in user }

    include_examples 'get change_locale'
  end
end
