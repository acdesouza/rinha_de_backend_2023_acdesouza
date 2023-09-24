class PessoasController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[ create ]

  before_action :set_pessoa, only: %i[ show ]

  # GET /pessoas
  def index
    render(plain: "query string `t` can't be blank", status: :bad_request) and return unless params[:t].present?

    render json: Pessoa.search(params[:t])
  end

  # GET /pessoas/1
  def show
    render json: @pessoa
  end

  # POST /pessoas
  def create
    @pessoa = Pessoa.new(pessoa_params)

    if @pessoa.save
      head :created, location: pessoa_path(@pessoa)
    else
      render json: { errors: @pessoa.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pessoa
      @pessoa = Pessoa.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pessoa_params
      params.require(:pessoa).permit(:apelido, :nome, :nascimento, :stack => [])
    end
end
