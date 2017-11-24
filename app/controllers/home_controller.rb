class HomeController < ApplicationController
  skip_before_action :authorize

  def index
    @data = [
      ['send','Když chceš mít pro rodinu a známé odpověď na otázku "a co by si chtěl k narozeninám?"','nasdílej s nimi svůj seznam'],
      ['check','Když nechceš dostávat stejné dárky dvakrát.','nech známé rezervovat dárky'],
      ['file','Když chceš mít jedno místo, kam si během roku zapíšeš co by tě potěšilo.','vytvoř si seznamy pro různé příležitosti'],
      ['barcode','Když už nechceš k vánocům a narozeninám dostávat cetky.','přej si konkrétní věci'],
      ['link','Když máš jasno v tom co si přeješ.','přidej odkazy do e-shopů']
    ]

    @gifts = Gift.preload(:urls).where(id: [100,4,103,104,99]).decorate
    @first = @gifts.first.id unless @gifts.count == 0
  end

  def glyphs; end

  def thank_you; end
end
