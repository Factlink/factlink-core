# coding: utf-8

LoadDsl.load do

  user "merijn", "merijn@gmail.com", "123hoi", "Merijn Terheggen"
  user "tomdev", "tom@factlink.com", "123hoi", "Tom de Vries"
  user "remon", "remon@factlink.com", "123hoi", "Remon Oldenbeuving"
  user "mark", "mark@factlink.com", "123hoi", "Mark IJbema"
  user "jjoos", "deelstra@factlink.com", "123hoi", "Jan Deelstra"
  user "jens", "jens@factlink.com", "123hoi", "Jens Kanis"
  user "martijn", "martijn@factlink.com", "123hoi", "Martijn Russchen"
  user "eamon", "eamon@factlink.com", "123hoi", "Eamon Nerbonne"
  user "luuk", "luuk@factlink.com", "123hoi", "Luuk Hartsema"

  as_user "tomdev" do
    fact "Oil is still detrimental to the environment,", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm" do
      believers "merijn","tomdev","jjoos", "mark", "jens", "eamon", "luuk"
      disbelievers "remon"

      comment "jens", "I totally agree, because I like plants and stuff."
      comment "luuk", "Are you on crack?"
      comment "tomdev", "Let's stay on topic and buy cr4ck at http://goo.gl/shine"

    end
    fact "Molecules that are not accessible to microbes persist and could have toxic effects", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm" do
      believers "merijn","tomdev"
      disbelievers "remon","mark","jjoos"

      comment "eamon", "This was because nutrients such as nitrogen and phosphorus -- usually essential to enable microbes to grow and make new cells -- were scarce in the water and oil in the slick."

    end
    fact "Oil that is consumed by microbes \"is being converted to carbon dioxide that still gets into the atmosphere.\"", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm" do
      believers "merijn","jjoos"
      disbelievers "tomdev","mark"

      comment "mark", "All your base are belong to us. So give your Pokémon and your children and head towards the mountains with the horses we provided."
      comment "remon", "?"

    end
    fact "The dynamic microbial community of the Gulf of Mexico supported remarkable rates of oil respiration, despite a dearth of dissolved nutrients,", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm" do
      believers "tomdev","mark"
      disbelievers "merijn","jjoos"
    end
    fact "Microbes had the metabolic potential to break down a large portion of hydrocarbons and keep up with the flow rate from the wellhead", "http://www.sciencedaily.com/releases/2011/08/110801111752.htm" do
      disbelievers "jjoos"
    end
    fact "the molecules that are not accessible to microbes persist and could have toxic effects", "http://example.org/" do
      believers "jjoos"
      disbelievers "tomdev"
    end
    fact "Cook served as Apple CEO for two months in 2004, when Jobs was recovering from pancreatic cancer surgery. In 2009, Cook again served as Apple CEO for several months while Jobs took a leave of absence for a liver transplant.", "http://en.wikipedia.org/wiki/Tim_Cook" do
      believers "tomdev"
      disbelievers "jjoos"

    end
    fact "Most bacterial infections can be treated with antibiotics such as penicillin, discovered decades ago. However, such drugs are useless against viral infections", "http://www.sciencedaily.com/" do
      believers "tomdev","jjoos"
    end
  end

  as_user "jjoos" do
    fact "The plant Arabidopsis thaliana is found throughout the entire northern hemisphere", "http://www.sciencedaily.com/" do
      believers "jjoos"
    end
    fact "When viruses infect a cell, they take over its cellular machinery for their own purpose -- that is, creating more copies of the virus.", "http://www.sciencedaily.com/releases/2011/08/110826134012.htm" do
      believers "jjoos"
    end
    fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.", "http://slashdot.org/" do
      believers "jjoos"
    end
    fact ". Google plans to shut down the social applications developed by Slide, a company it acquired a year ago for US$182 million.  ", "http://localhost:3000/" do
      believers "jjoos"

      comment "luuk", "I like money $$$$"
    end
    fact "Obesity is growing at alarming rates worldwide, and the biggest culprit is overeating", "http://www.sciencedaily.com/" do
      believers "jjoos"
    end
    fact " New Depiction of Light Could Boost Telecommunications Channels Physicists have presented a new way to map spiraling light that could help harness untapped data channels in optical fibers. Increased bandwidth would ease the burden on fiber-optic telecommunications networks taxed ...  > full story more on: Optics; Graphene; Inorganic Chemistry; Chemistry; Physics; Computer Modeling ", "http://www.sciencedaily.com/" do
      disbelievers "jjoos"
    end
    fact " First Glimpse Into Birth of the Milky Way For almost 20 years astrophysicists have been trying to recreate the formation of spiral galaxies such as our Milky Way realistically. Now astrophysicists and astronomers present the world's first realistic simulation of the ...  > full story more on: Galaxies; Astrophysics; Stars; Astronomy; Dark Matter; Solar System ", "http://www.sciencedaily.com/" do
      disbelievers "jjoos"
    end
    fact "De veiligheid van liften in Nederland is in gevaar doordat vier van de zes bedrijven die liften mogen keuren niet onafhankelijk zijn van hun opdrachtgevers. ", "http://www.nrc.nl/nieuws/2011/08/29/veiligheid-liften-in-gevaar-omdat-keuringen-niet-onafhankelijk-zijn/" do
      believers "jjoos"
    end
    fact "Stanford microsurgeons have used a poloxamer gel and bioadhesive, rather than a needle and thread, to join together blood vessels", "http://slashdot.org/" do
      disbelievers "jjoos"
    end
    fact "\"On earth, nuclear reactors are under attack because of concerns over damage caused by natural disasters. In space, however, nuclear technology may get a new lease on life.", "http://slashdot.org/" do
      believers "jjoos"
    end
  end
end
