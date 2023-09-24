class ContagemPessoasController < ApplicationController
  def show
    render plain: Pessoa.count
  end
end
