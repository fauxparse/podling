RSpec.describe Podling::Admin::EpisodesController, type: :request do
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
    before { get admin_episodes_path }

    it { is_expected.to be_successful }

    describe 'request body' do
      subject { response.body }

      it { is_expected.to include published_episode.title }
      it { is_expected.to include unpublished_episode.title }
      it { is_expected.to include deleted_episode.title }
    end
  end

  describe '#show' do
    context 'for a published episode' do
      before { get admin_episode_path(published_episode) }

      it { is_expected.to be_successful }

      describe 'request body' do
        subject { response.body }

        it { is_expected.to include published_episode.title }
      end
    end
  end

  describe '#new' do
    before { get new_admin_episode_path }

    it { is_expected.to be_successful }
  end

  describe '#create' do
    let(:do_create) { post admin_episodes_path, params: params }
    let(:audio) do
      Rack::Test::UploadedFile.new(
        File.expand_path('../../../files/sample.mp3', __dir__),
        'audio/mpeg'
      )
    end

    context 'with good parameters' do
      let(:params) do
        {
          episode: {
            title: 'The Great Conjunction',
            description: 'When single shines the triple sun...',
            audio: audio
          }
        }
      end

      it 'creates an episode' do
        expect { do_create }.to change(Podling::Episode, :count).by(1)
      end

      it 'redirects' do
        do_create
        expect(response)
          .to redirect_to admin_episode_path(Podling::Episode.last)
      end

      describe 'the created episode' do
        subject(:episode) { Podling::Episode.last }

        before { do_create }

        it { is_expected.not_to be_published }

        it 'has the correct title' do
          expect(episode.title).to eq params[:episode][:title]
        end

        it 'has the correct description' do
          expect(episode.description).to eq params[:episode][:description]
        end

        it 'has attached audio' do
          expect(episode.audio).to be_attached
        end
      end

      context 'with the published flag' do
        before { params[:episode][:publish] = '1' }

        it 'publishes the new episode' do
          expect { do_create }
            .to change { Podling::Episode.count }.by(1)
            .and change { Podling::Episode.published.count }.by(1)
        end

        describe 'the created episode' do
          subject(:episode) { Podling::Episode.last }

          before { do_create }

          it { is_expected.to be_published }
        end
      end
    end

    context 'with bad parameters' do
      let(:params) do
        {
          episode: {}
        }
      end

      describe 'the created episode' do
        subject(:episode) { Podling::Episode.last }

        it 'does not create an episode' do
          expect { do_create }.not_to change(Podling::Episode, :count)
        end

        it 'renders errors' do
          do_create
          expect(response.body).to match(/Title can(.+)t be blank/)
        end
      end
    end
  end

  describe '#edit' do
    before { get edit_admin_episode_path(episode) }

    context 'for a published episode' do
      let(:episode) { published_episode }

      it { is_expected.to be_successful }
    end

    context 'for an unpublished episode' do
      let(:episode) { unpublished_episode }

      it { is_expected.to be_successful }
    end

    context 'for a deleted episode' do
      let(:episode) { deleted_episode }

      it { is_expected.to be_successful }
    end
  end

  describe '#update' do
    let(:do_update) do
      patch admin_episode_path(episode), params: params
    end

    let(:episode) { unpublished_episode.tap(&:save) }

    context 'with good params' do
      let(:params) do
        {
          episode: {
            title: 'New title',
            publish: '1'
          }
        }
      end

      it 'updates the title' do
        expect { do_update }
          .to change { episode.reload.title }
          .from(episode.title)
          .to(params[:episode][:title])
      end

      it 'publishes the episode' do
        expect { do_update }
          .to change { episode.reload.published? }
          .from(false)
          .to(true)
      end

      it 'redirects to the episode' do
        do_update
        expect(response)
          .to redirect_to admin_episode_path(episode)
      end
    end

    context 'on a published episode' do
      let(:episode) { published_episode.tap(&:save) }

      let(:params) do
        {
          episode: {
            publish: '0'
          }
        }
      end

      it 'unpublishes the episode' do
        expect { do_update }
          .to change { episode.reload.published? }
          .from(true)
          .to(false)
      end
    end

    context 'with bad params' do
      let(:params) do
        {
          episode: {
            title: ''
          }
        }
      end

      it 'does not redirect' do
        do_update
        expect(response).not_to be_redirect
      end

      it 'renders an error message' do
        do_update
        expect(response.body).to match(/Title can(.+)t be blank/)
      end
    end
  end

  describe '#destroy' do
    let(:do_destroy) { delete admin_episode_path(episode) }
    let(:episode) { published_episode.tap(&:save) }

    it 'does not destroy the record' do
      expect { do_destroy }.not_to change(Podling::Episode, :count)
    end

    it 'soft-deletes the episode' do
      expect { do_destroy }
        .to change { Podling::Episode.deleted.count }.by(1)
    end
  end
end
