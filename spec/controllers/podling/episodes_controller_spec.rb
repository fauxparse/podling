RSpec.describe Podling::EpisodesController, type: :request do
  subject { response }

  let!(:unpublished_episode) do
    Podling::Episode.create!(title: 'Unpublished episode')
  end
  let!(:published_episode) do
    Podling::Episode.create!(title: 'Published episode').tap(&:publish!)
  end
  let!(:deleted_episode) do
    Podling::Episode.create!(title: 'Deleted episode').tap(&:delete!)
  end

  describe '#index' do
    before { get episodes_path }

    it { is_expected.to be_successful }

    describe 'request body' do
      subject { response.body }

      it { is_expected.to include published_episode.title }
      it { is_expected.not_to include unpublished_episode.title }
      it { is_expected.not_to include deleted_episode.title }
    end
  end

  describe '#show' do
    context 'for a published episode' do
      before { get episode_path(published_episode) }

      it { is_expected.to be_successful }

      describe 'request body' do
        subject { response.body }

        it { is_expected.to include published_episode.title }
      end
    end

    context 'for an unpublished episode' do
      before { get episode_path(unpublished_episode) }

      it { is_expected.to have_http_status(:not_found) }
    end

    context 'for a deleted episode' do
      before { get episode_path(deleted_episode) }

      it { is_expected.to have_http_status(:not_found) }
    end
  end
end
