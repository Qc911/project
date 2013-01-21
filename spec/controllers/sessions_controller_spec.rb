require 'spec_helper'

describe SessionsController do#0
  render_views

  describe "GET 'new'" do#1

    it "devrait reussir" do#2
      get :new
      response.should be_success
    end#2

    it "devrait avoir le bon titre" do#2
      get :new
      response.should have_selector("title", :content => "S'identifier")
    end#2
  end#1

describe "POST 'create'" do#1

    describe "invalid signin" do#2

      before(:each) do#3
        @attr = { :email => "email@example.com", :password => "invalid" }
      end#3

      it "devrait re-rendre la page new" do#3
        post :create, :session => @attr
        response.should render_template('new')
      end#3

      it "devrait avoir le bon titre" do#3
        post :create, :session => @attr
        response.should have_selector("title", :content => "S'identifier")
      end#3

      it "devait avoir un message flash.now" do#3
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end#3
    end#2

    describe "avec un email et un mot de passe valides" do#2

      before(:each) do#3
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end#3

      it "devrait identifier l'utilisateur" do#3
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end#3
	
      it "devrait rediriger vers la page d'affichage de l'utilisateur" do#3
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end#3
    end#2
  end#1
  
  describe "DELETE 'destroy'" do#1

    it "devrait deconnecter un utilisateur" do#2
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end#2
  end#1
end#0
