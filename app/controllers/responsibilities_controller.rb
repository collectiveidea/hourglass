class ResponsibilitiesController < ApplicationController
  include HasHarvest

  def index
    @responsibilities = Responsibility.ordered # TODO: .active
  end

  def new
    @responsibility = Responsibility.new
  end

  def create
    @responsibility = Responsibility.new(responsibility_attributes)

    if @responsibility.save
      redirect_to responsibilities_path
    else
      render :new
    end
  end

  def edit
    @responsibility = Responsibility.find(params[:id])
  end

  def update
    @responsibility = Responsibility.find(params[:id])

    if @responsibility.update(responsibility_attributes)
      redirect_to responsibilities_path
    else
      base_errors = @responsibility.errors.full_messages_for(:base)
      flash.now[:alert] = base_errors.join(" ") if base_errors.present?
      render :edit
    end
  end

  def destroy
    @responsibility = Responsibility.find(params[:id])

    @responsibility.archive

    redirect_to responsibilities_path
  end

  def reorder
    Responsibility.reorder(params[:id], params[:position])

    head :no_content
  end

  private

  def harvest_clients
    @harvest_clients ||= harvest.clients.all
  end

  helper_method :harvest_clients

  def responsibility_attributes
    params.require(:responsibility).permit(
      :title,
      :adjective,
      :default,
      harvest_client_ids: [],
    )
  end
end
