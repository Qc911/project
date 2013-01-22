require 'spec_helper'

describe User do#0

   before(:each) do#1
    @attr = {
      :nom => "Utilisateur exemple",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
   end#1

  it "devrait creer une nouvelle instance dotee des attributs valides" do#2
    User.create!(@attr)
  end#2

  it "exige un nom" do#2
    bad_guy = User.new(@attr.merge(:nom => ""))
    bad_guy.should_not be_valid
  end#2
  
  it "exige une adresse email" do#2
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end#2
  
   it "devrait rejeter les noms trop longs" do#2
    long_nom = "a" * 51
    long_nom_user = User.new(@attr.merge(:nom => long_nom))
    long_nom_user.should_not be_valid
  end#2
  
   it "devrait accepter une adresse email valide" do#2
    adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    adresses.each do |address|#3
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end#3
  end#2

  it "devrait rejeter une adresse email invalide" do#2
    adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    adresses.each do |address|#3
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end#3
  end#2
  
  it "devrait rejeter un email double" do#2
    # Place un utilisateur avec un email donné dans la BD.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end#2
  
  it "devrait rejeter une adresse email invalide jusqu'a la casse" do#2
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end#2
  
   describe "password validations" do#2

    it "devrait exiger un mot de passe" do#3
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end#3

    it "devrait exiger une confirmation du mot de passe qui correspond" do#3
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end#3

    it "devrait rejeter les mots de passe (trop) courts" do#3
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end#3

    it "devrait rejeter les (trop) longs mots de passe" do#3
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end#3
  end#2
  
  describe "password encryption" do#2

    before(:each) do#3
      @user = User.create!(@attr)
    end#3

    it "devrait avoir un attribut  mot de passe crypte" do#3
      @user.should respond_to(:encrypted_password)
    end#3
   
   it "devrait definir le mot de passe crypte" do#3
      @user.encrypted_password.should_not be_blank
    end#3
  
   describe "Methode has_password?" do#3

      it "doit retourner true si les mots de passe coincident" do#4
        @user.has_password?(@attr[:password]).should be_true
      end#4

      it "doit retourner false si les mots de passe divergent" do#4
        @user.has_password?("invalide").should be_false
      end #4
    end#3
  
  
  describe "authenticate method" do#3

      it "devrait retourner nul en cas d'inequation entre email/mot de passe" do#4
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end#4

      it "devrait retourner nil quand un email ne correspond a aucun utilisateur" do#4
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end#4

      it "devrait retourner l'utilisateur si email/mot de passe correspondent" do#4
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end#4
    end#3
  end#2

  describe "Attribut admin" do#2

    before(:each) do#3
      @user = User.create!(@attr)
    end#3

    it "devrait confirmer l'existence de `admin`" do#3
      @user.should respond_to(:admin)
    end#3

    it "ne devrait pas etre un administrateur par defaut" do#3
      @user.should_not be_admin
    end#3

    it "devrait pouvoir devenir un administrateur" do#3
      @user.toggle!(:admin)
      @user.should be_admin
    end#3
  end#2

  describe "les associations au micro-message" do#2

    before(:each) do#3
      @user = User.create(@attr)
    end#3

    it "devrait avoir un attribut 'microposts'" do#3
      @user.should respond_to(:microposts)
    end#3
  end#2

  describe "micropost associations" do#2

    before(:each) do#3
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end#3

    it "devrait avoir un attribut `microposts`" do#3
      @user.should respond_to(:microposts)
    end#3

    it "devrait avoir les bons micro-messags dans le bon ordre" do#3
      @user.microposts.should == [@mp2, @mp1]
    end#3
  
    it "devrait detruire les micro-messages associes" do#3
      @user.destroy
      [@mp1, @mp2].each do |micropost|#4
        Micropost.find_by_id(micropost.id).should be_nil
      end#4
    end#3
      
      describe "Etat de l'alimentation" do#4

      it "devrait avoir une methode `feed`" do#5
        @user.should respond_to(:feed)
      end#5

      it "devrait inclure les micro-messages de l'utilisateur" do#5
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end#5

      it "ne devrait pas inclure les micro-messages d'un autre utilisateur" do#5
        mp3 = Factory(:micropost,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp3).should be_false
        end#5
      end#4
    end#3
end#0
