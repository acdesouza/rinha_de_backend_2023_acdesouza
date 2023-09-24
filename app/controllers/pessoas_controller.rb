class PessoasController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[ create ]

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

    # Only allow a list of trusted parameters through.
    def pessoa_params
      params.require(:pessoa).permit(:apelido, :nome, :nascimento, :stack => [])
    end
end
