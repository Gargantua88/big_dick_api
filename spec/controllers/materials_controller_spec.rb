require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  before do
    expect(controller).to receive(:authorize_by_token).and_return(true)
  end

  describe '#create' do
    before do
      @params = {
          title: 'La-da-da-da-dahh',
          body: 'Its the motherfuckin D-O-double-G',
          cover_url: 'snoop/dogg.jpg',
          link: '/la/da/da-da-dahh.html',
          announcement: 'You know Im mobbin with the D.R.E.',
          published_date: '2019.01.01'
      }
    end

    it 'creates material' do
      post :create, params: {material: @params}

      expect(Material.where(@params).count).to eq 1
    end

    it 'creates heading with material' do
      heading_params = {slug: 'cat', title: 'bestcats'}

      post :create, params: {material: @params.merge(heading: heading_params)}

      heading = Heading.where(heading_params).first
      expect(heading).to be
      expect(heading.materials.first.title).to eq 'La-da-da-da-dahh'
    end

    it 'updates heading by slug' do
      heading = Heading.create!(slug: 'heading1', title: 'old title')

      post :create, params: {material: @params.merge(heading: {slug: 'heading1', title: 'new title'})}

      heading.reload

      expect(heading.title).to eq 'new title'
      expect(heading.materials.first.title).to eq 'La-da-da-da-dahh'
    end

    it 'creates tags with material' do
      tags_params = [{slug: '2pac', title: 'Shakur'}, {slug: 'Coolio', title: 'Paradise'}]

      post :create, params: {material: @params.merge(tags: tags_params)}

      tag = Tag.find_by(slug: 'Coolio', title: 'Paradise')

      expect(tag).to be
      expect(tag.materials.first.title).to eq 'La-da-da-da-dahh'
    end

    it 'updates tags by slug' do
      tag = Tag.create!(slug: 'heading1', title: 'old title')

      post :create, params: {material: @params.merge(tags: [{slug: 'heading1', title: 'new title'}])}

      tag.reload

      expect(tag.title).to eq 'new title'
      expect(tag.materials.first.title).to eq 'La-da-da-da-dahh'
    end
  end

  describe '#index' do
    before do
      @materials = (1..4).map do |i|
        Material.create!(title: "Yeah #{i}",
                         body: 'I know sometimes',
                         cover_url: 'things_may/not_always/make_sense.jpg',
                         link: "/to_you/right_now#{i}.html",
                         announcement: 'But hey, what daddy always tell you?',
                         published_date: "2019.02.0#{i}"
        )
      end
    end

    it 'filters by ids and heading_slug' do
      heading1 = Heading.create!(slug: 'slug_1', title: 'title 1')
      heading2 = Heading.create!(slug: 'slug_2', title: 'title 2')

      heading1.materials << @materials[0]
      heading1.materials << @materials[3]
      heading2.materials << @materials[2]

      get :index, params: {ids: [@materials[0].id, @materials[1].id, @materials[2].id], heading_slug: 'slug_1'}

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response.first['title']).to eq 'Yeah 1'
    end

    it 'filters by ids and tag_slug' do
      tag1 = Tag.create!(slug: 'slug_1', title: 'title 1')
      tag2 = Tag.create!(slug: 'slug_2', title: 'title 2')

      tag1.materials << @materials[0]
      tag1.materials << @materials[2]
      tag2.materials << @materials[3]

      get :index, params: {ids: [@materials[0].id, @materials[1].id, @materials[2].id], tag_slug: 'slug_1'}

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response.first['title']).to eq 'Yeah 1'
      expect(json_response.second['title']).to eq 'Yeah 3'
    end

    it 'sorted by id asc' do
      # Перемешаем материалы между собой, чтобы быть уверенным, что сортировка работает
      @materials.shuffle!

      get :index, params: {sort: 'id', order: 'asc'}

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 4
      expect(json_response.first['title']).to eq 'Yeah 1'
      expect(json_response.last['title']).to eq 'Yeah 4'
    end

    it 'sorted by id desc' do
      # Перемешаем материалы между собой, чтобы быть уверенным, что сортировка работает
      @materials.shuffle!

      get :index, params: {sort: 'id', order: 'desc'}

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 4
      expect(json_response.first['title']).to eq 'Yeah 4'
      expect(json_response.last['title']).to eq 'Yeah 1'
    end

    it 'sorted by published_date asc' do
      # Перемешаем материалы между собой, чтобы быть уверенным, что сортировка работает
      @materials.shuffle!

      get :index, params: {sort: 'published_date', order: 'asc'}

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 4
      expect(json_response.first['title']).to eq 'Yeah 1'
      expect(json_response.last['title']).to eq 'Yeah 4'
    end

    it 'sorted by published_date desc' do
      # Перемешаем материалы между собой, чтобы быть уверенным, что сортировка работает
      @materials.shuffle!

      get :index, params: {sort: 'published_date', order: 'desc'}

      json_response = JSON.parse(response.body)

      expect(json_response.length).to eq 4
      expect(json_response.first['title']).to eq 'Yeah 4'
      expect(json_response.last['title']).to eq 'Yeah 1'
    end

    it 'filters and sorted by id in desc' do
      tag1 = Tag.create!(slug: 'slug_1', title: 'title 1')
      tag2 = Tag.create!(slug: 'slug_2', title: 'title 2')

      tag1.materials << @materials[0]
      tag1.materials << @materials[2]
      tag1.materials << @materials[1]
      tag2.materials << @materials[3]

      get :index, params: {ids: [@materials[0].id, @materials[1].id, @materials[2].id], tag_slug: 'slug_1',
                           sort: 'id', order: 'asc'
      }

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3
      expect(json_response.first['title']).to eq 'Yeah 1'
      expect(json_response.second['title']).to eq 'Yeah 2'
      expect(json_response.last['title']).to eq 'Yeah 3'
    end

    it 'filters and sorted by published_date in desc' do
      tag1 = Tag.create!(slug: 'slug_1', title: 'title 1')
      tag2 = Tag.create!(slug: 'slug_2', title: 'title 2')

      tag1.materials << @materials[0]
      tag1.materials << @materials[2]
      tag1.materials << @materials[1]
      tag2.materials << @materials[3]

      get :index, params: {ids: [@materials[0].id, @materials[1].id, @materials[2].id], tag_slug: 'slug_1',
                           sort: 'published_date', order: 'desc'
      }

      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 3
      expect(json_response.first['title']).to eq 'Yeah 3'
      expect(json_response.second['title']).to eq 'Yeah 2'
      expect(json_response.last['title']).to eq 'Yeah 1'
    end
  end

  describe '#update' do
    before do
      @material = Material.create!(
          title: 'Cats',
          body: 'all u need is cats',
          cover_url: 'imgs/2018/03/12/314135135.jpg',
          link: '/kotiki/persidskie/kak-kormit-kota.html',
          announcement: 'cats everywhere',
          published_date: '2019.02.02'
      )

      @params = {
          title: 'La-da-da-da-dahh',
          body: 'Its the motherfuckin D-O-double-G',
          cover_url: 'snoop/dogg.jpg',
          link: '/la/da/da-da-dahh.html',
          announcement: 'You know Im mobbin with the D.R.E.',
          published_date: '2019.03.03'
      }
    end

    it 'updates material' do
      put :update, params: {id: @material.id, material: @params}

      @material.reload

      expect(@material.title).to eq 'La-da-da-da-dahh'
      expect(@material.body).to eq 'Its the motherfuckin D-O-double-G'
      expect(@material.cover_url).to eq 'snoop/dogg.jpg'
      expect(@material.link).to eq '/la/da/da-da-dahh.html'
      expect(@material.announcement).to eq 'You know Im mobbin with the D.R.E.'
      expect(@material.published_date).to eq '2019.03.03'
    end

    it 'updates heading with material' do
      heading_params = {
          slug: 'heading_slug',
          title: 'heading title'
      }

      put :update, params: {id: @material.id, material: @params.merge(heading: heading_params)}

      @material.reload

      expect(@material.heading).to be
      expect(@material.heading.title).to eq 'heading title'
      expect(@material.heading.slug).to eq 'heading_slug'
    end

    it 'updates tags with material' do
      tags_params = [{slug: 'tag_slug1', title: 'tag slug 1'}, {slug: 'tag_slug_2', title: 'tag slug 2'}]

      put :update, params: {id: @material.id, material: @params.merge(tags: tags_params)}

      @material.reload

      expect(@material.tags).to be
      expect(@material.tags.length).to eq 2
      expect(@material.tags.first.title).to eq 'tag slug 1'
      expect(@material.tags.last.slug).to eq 'tag_slug_2'
    end

    it 'updates heading by slug' do
      heading = Heading.create!(slug: 'heading_slug', title: 'old title')

      post :create, params: {material: @params.merge(heading: {slug: 'heading_slug', title: 'new title'})}

      heading.reload

      expect(heading.title).to eq 'new title'
    end

    it 'updates tag by slug' do
      tag1 = Tag.create!(slug: 'tag_slug_1', title: 'old title 1')
      tag2 = Tag.create!(slug: 'tag_slug_2', title: 'old title 2')

      post :create, params: {material: @params.merge(tags: [{slug: 'tag_slug_1', title: 'new title 1'},
                                                            {slug: 'tag_slug_2', title: 'old title 2'}
      ])}

      tag1.reload
      tag2.reload

      expect(tag1.title).to eq 'new title 1'
      expect(tag2.title).to eq 'old title 2'
    end

    it 'doesnt delete heading if it doesnt present in params' do
      heading = Heading.create!(slug: 'heading_1', title: 'old title')
      heading.materials << @material

      post :create, params: {material: @params}

      @material.reload

      expect(@material.heading.title).to eq 'old title'
      expect(@material.heading.slug).to eq 'heading_1'
    end

    it 'doesnt delete tags if they dont present in params' do
      tag1 = Tag.create!(slug: 'tag_slug_1', title: 'old title 1')
      tag2 = Tag.create!(slug: 'tag_slug_2', title: 'old title 2')
      @material.tags << tag1
      @material.tags << tag2

      post :create, params: {material: @params}

      @material.reload

      expect(@material.tags.first.title).to eq 'old title 1'
      expect(@material.tags.last.title).to eq 'old title 2'
    end
  end

  describe '#delete' do
    before do
      @material1 = Material.create!(
          title: 'Cats',
          body: 'all u need is cats',
          cover_url: 'imgs/2018/03/12/314135135.jpg',
          link: '/kotiki/persidskie/kak-kormit-kota.html',
          announcement: 'cats everywhere',
          published_date: '2019.02.02'
      )

      @material2 = Material.create!(
          title: 'La-da-da-da-dahh',
          body: 'Its the motherfuckin D-O-double-G',
          cover_url: 'snoop/dogg.jpg',
          link: '/la/da/da-da-dahh.html',
          announcement: 'You know Im mobbin with the D.R.E.',
          published_date: '2019.01.01'
      )
    end

    it 'just delete material' do
      delete :destroy, params: {id: @material1.id}

      expect(Material.all.length).to eq 1
      expect(Material.first.title).to eq 'La-da-da-da-dahh'
    end

    it 'doesnt delete heading and tags' do
      heading = Heading.create!(slug: 'heading_1', title: 'old title')
      heading.materials << @material1
      heading.materials << @material2

      tag1 = Tag.create!(slug: 'tag_slug_1', title: 'old title 1')
      tag2 = Tag.create!(slug: 'tag_slug_2', title: 'old title 2')
      @material1.tags << tag1
      @material1.tags << tag2
      @material2.tags << tag1

      delete :destroy, params: {id: @material1.id}

      heading.reload
      tag1.reload
      tag2.reload

      expect(Material.all.length).to eq 1
      expect(heading.materials.length).to eq 1
      expect(heading.materials.first.title).to eq 'La-da-da-da-dahh'
      expect(tag1.materials.length).to eq 1
      expect(tag1.materials.first.title).to eq 'La-da-da-da-dahh'
      expect(tag2.materials).to eq []
    end
  end
end
