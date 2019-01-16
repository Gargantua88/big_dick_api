class MaterialsController < ApplicationController
  before_action :set_material, only: [:update, :destroy]

  def index
    @materials = Material.all

    # Фильтрация по списку id
    @materials = @materials.where(id: params[:ids]) if params[:ids].present?

    # Фильтрация по heading
    if params[:heading_slug].present?
      @materials = @materials.joins(:heading).where(headings: {slug: params[:heading_slug]})
    end

    # Фильтрация по tag
    @materials = @materials.joins(:tags).where(tags: {slug: params[:tag_slug]}) if params[:tag_slug].present?

    # Сортировка
    @materials = @materials.order(id: :asc) if params[:sort] == 'id' && params[:order] == 'asc'
    @materials = @materials.order(id: :desc) if params[:sort] == 'id' && params[:order] == 'desc'
    @materials = @materials.order(published_date: :desc) if params[:sort] == 'published_date' && params[:order] == 'desc'
    @materials = @materials.order(published_date: :asc) if params[:sort] == 'published_date' && params[:order] == 'asc'

    render json: @materials
  end

  def show
    @material = Material.find(params[:id]) if params[:id].present?

    @material = Material.find_by(link: params[:link]) if params[:link].present?

    render json: @material
  end

  def create
    @material = Material.new(material_params)

    add_heading
    add_tags

    if @material.save
      render json: @material, status: :created, location: @material
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  def update
    add_heading
    add_tags

    if @material.update(material_params)
      render json: @material
    else
      render json: @material.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @material.destroy
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.fetch(:material, {}).permit(:title, :announcement, :cover_url, :body, :link, :published_date)
  end

  def material_heading_params
    params.fetch(:material, {}).fetch(:heading, {}).permit(:slug, :title)
  end

  # Parameters: {"material"=>{"title"=>"2pac", "heading"=>{"slug"=>"2pac", "title"=>"shakur"}}}

  def add_heading
    if material_heading_params.present?
      @material.heading = Heading.where(slug: material_heading_params[:slug]).first_or_initialize

      # Перезапишем title, даже если slug существовал
      @material.heading.title = material_heading_params[:title]
    end
  end

  def material_tags_params
    params.fetch(:material, {}).fetch(:tags, {}).each { |tag| tag.permit(:slug, :title) }
  end

  # Parameters: {"material"=>{"title"=>"cats",
  # "tags"=>[{"slug"=>"cats", "title"=>"pussycats"}, {"slug"=>"dogs", "title"=>"snoopdoggs"}]}}

  def add_tags
    if material_tags_params.present?
      material_tags_params.map do |tag|
        current_tag = Tag.where(slug: tag[:slug]).first_or_initialize

        # Перезапишем title, даже если slug существовал
        current_tag.title = tag[:title]
        @material.tags << current_tag
      end
    end
  end
end
