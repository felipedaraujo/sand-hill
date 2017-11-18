class ProtocolsController < ApplicationController
  before_action :set_protocol, only: [:show, :update, :destroy]

  # GET /protocols
  def index
    search = params[:term].present? ? params[:term] :nil

    @protocols = if search
      Protocol.search(search)
    else
      Protocol.limit(10)
    end

    render json: @protocols
  end

  # GET /protocols/1
  def show
    render json: @protocol
  end

  # POST /protocols
  def create
    @protocol = Protocol.new(protocol_params)

    if @protocol.save
      render json: @protocol, status: :created, location: @protocol
    else
      render json: @protocol.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /protocols/1
  def update
    if @protocol.update(protocol_params)
      render json: @protocol
    else
      render json: @protocol.errors, status: :unprocessable_entity
    end
  end

  # DELETE /protocols/1
  def destroy
    @protocol.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_protocol
      @protocol = Protocol.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def protocol_params
      params.require(:protocol).permit(:tile, :abstract, :materials_and_methods, :journal, :journal_id, :publication_date)
    end
end
