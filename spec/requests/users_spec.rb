require 'spec_helper'

describe "Users" do#0

  describe "Une inscription" do#1

    describe "ratee" do#2

      it "ne devrait pas creer un nouvel utilisateur" do#3
        lambda do#4
          visit signup_path
          fill_in "Nom", :with => ""
          fill_in "eMail", :with => ""
          fill_in "Mot de passe", :with => ""
          fill_in "Confirmation mot de passe", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)#4
      end#3
    end#2

  describe "reussie" do#2

      it "devrait creer un nouvel utilisateurr" do#3
        lambda do#4
          visit signup_path
          fill_in "Nom", :with => "Example User"
          fill_in "eMail", :with => "user@example.com"
          fill_in "Mot de passe", :with => "foobar"
          fill_in "Confirmation mot de passe", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)#4
      end#3
    end#2
  end#1
end#0
