class UsersController < ApplicationController

  def show#0
    @user = User.find(params[:id])
    @titre = @user.nom
  end#0

  def new#0
    @user = User.new
    @titre = "Inscription"
  end#0

  def create#0
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Bienvenue dans l'Application Exemple !"
      redirect_to @user
    else
      @titre = "Sign up"
      render 'new'
    end#0
  end
end
