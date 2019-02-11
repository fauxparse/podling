RSpec.describe Podling::Episode do
  subject(:episode) { Podling::Episode.new(title: 'Sample episode') }

  it { is_expected.not_to be_published }
  it { is_expected.not_to be_deleted }

  context 'without a title' do
    before { episode.title = nil }

    it { is_expected.not_to be_valid }
  end

  context 'when published' do
    before { episode.publish! }

    it { is_expected.to be_published }

    describe '.published' do
      subject(:published) { Podling::Episode.published }

      it { is_expected.to include episode }
    end

    describe '.deleted' do
      subject(:deleted) { Podling::Episode.deleted }

      it { is_expected.not_to include episode }
    end
  end

  context 'when deleted' do
    before { episode.publish!.delete! }

    it { is_expected.to be_deleted }
    it { is_expected.not_to be_published }

    describe '.published' do
      subject(:published) { Podling::Episode.published }

      it { is_expected.not_to include episode }
    end

    describe '.deleted' do
      subject(:deleted) { Podling::Episode.deleted }

      it { is_expected.to include episode }
    end
  end

  context 'with publish set' do
    before { episode.publish = true }

    it 'publishes on create' do
      expect { episode.save! }
        .to change { Podling::Episode.count }.by(1)
        .and change { Podling::Episode.published.count }.by(1)
    end
  end
end
