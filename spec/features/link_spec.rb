describe "links" do

  context "navigation" do
    before(:each) do
      visit root_path
    end

    describe "prompt pass" do
      it "renders the link" do
        expect(page).to have_link "Prompt Pass"
      end

      it "links to about page" do
        click_link "Prompt Pass"
        expect(page).to have_content "Send secrets with secure two factor messaging"
        expect(current_url).to include root_path
      end
    end

    describe "about" do
      it "renders the link" do
        expect(page).to have_link "About"
      end

      it "links to about page" do
        click_link "About"
        expect(current_url).to include about_path
      end
    end

    describe "send a secret" do
      it "renders the link" do
        expect(page).to have_link "Send a secret"
      end

      it "links to new secret page" do
        click_link "Send a secret"
        expect(current_url).to include create_secret_path
        expect(page).to have_content "Write your secret message"
      end
    end
  end

  context "home page" do
    before(:each) do
      visit root_path
    end

    context "body links" do
      describe "send your own secret message" do
        it "renders the link" do
          expect(page).to have_link "Send your own secret message"
        end

        it "links to new secret page" do
          click_link "Send your own secret message"
          expect(current_url).to include create_secret_path
          expect(page).to have_content "Write your secret message"
        end
      end
    end
  end

  context "about page" do
    before(:each) do
      visit about_path
    end

    context "body links" do
      describe "wikipedia link" do
        it "renders the link" do
          expect(page).to have_link "Wikipedia Article"
        end
      end

      context "github links" do
        describe "kathleen" do
          it "renders the link" do
            expect(page).to have_link "Github", href: "https://github.com/kathleenAMA"
          end
        end

        describe "michael" do
          it "renders the link" do
            expect(page).to have_link "Github", href: "https://github.com/mvandenbeuken"
          end
        end

        describe "ruben" do
          it "renders the link" do
            expect(page).to have_link "Github", href: "https://github.com/rubene"
          end
        end

        describe "ryan" do
          it "renders the link" do
            expect(page).to have_link "Github", href: "https://github.com/ryanjones"
          end
        end
      end

      describe "issues link" do
        it "renders the link" do
          expect(page).to have_link "here", href: "https://github.com/railsrumble/r15-team-193/issues"
        end
      end
    end
  end
end
