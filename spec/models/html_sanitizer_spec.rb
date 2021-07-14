require 'rails_helper'

RSpec.describe HtmlSanitizer, type: :model do
  partial_allow_list = %w[b br h1 div span ol ul li]

  let(:sanitizer) { described_class.new(string) }

  describe '#sanitize' do
    subject { sanitizer.sanitize }

    let(:string) do
      %{
      <div class="title is-3">About us</div>
      <script>alert('I did something bad!');</script>
      <ul>
        <ol>
          <li>
            <h1 class='title is-5'>What is Mutual Aid?</h1>
            <br><br>
            <span class='title is-5'>Why is Mutual Aid necessary?</span>
            <span class="has-text-weight-bold">Mutual Aid</span> fills gaps.
            It is <b>homegrown</b> and grassroots.
          </li>
        </ol>
      </ul>
    }
    end

    it 'removes dangerous tags' do
      expect(subject).not_to match('<script>')
    end

    describe 'keeps allow-listed tags' do
      partial_allow_list.each do |tag|
        it "allows <#{tag}>" do
          expect(subject).to match("<#{tag}[ >]")
        end
      end
    end

    it 'keeps attributes of span and div tags' do
      expect(subject).to include('<span class="has-text-weight-bold">')
      expect(subject).to include('<div class="title is-3">')
    end
  end
end
