require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#present' do
    context 'without a block' do
      subject(:presenter) { helper.present Object.new, AnnouncementPresenter }

      it { is_expected.to be_an AnnouncementPresenter }

      it 'passed view_context through to the presenter' do
        expect(presenter.h).to be_a ActionView::Context
      end
    end

    context 'with a block' do
      it 'yields an instance of the presenter_class' do
        expect { |b| helper.present Object.new, AnnouncementPresenter, &b }.to yield_with_args AnnouncementPresenter
      end
    end
  end
end
