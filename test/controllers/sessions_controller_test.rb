class SessionsController < ApplicationController
  def create
    # Busca o usuário pelo nome ou documento
    user = User.find_by(name: params[:session][:name]) # ou `document`, dependendo do que deseja usar

    # Verifica se a autenticação da senha foi bem-sucedida
    if user&.authenticate(params[:session][:password])
      render json: { message: 'Login bem-sucedido!', user: user }, status: :ok
    else
      render json: { error: 'Falha no login.' }, status: :unauthorized
    end
  end
end
