class HomeController < ApplicationController
  skip_before_action :authorize

  def index
    @data = [
      ['pushpin','Když chceš mít jedno místo kam si během roku zapíšeš co by tě potěšilo.','vytvoř si seznamy pro různé příležitosti'],
      ['barcode','Když už nechceš k vánocům a narozeninám dostávat cetky.','přej si konkrétní věci'],
      ['link','Když máš jasno v tom co chceš.','přidej odkazy do e-shopů'],
      ['send','Když chceš mít pro rodinu a známé odpověď na otázku "a co bych si chtěl k narozeninám?"','nasdílej s nimi svůj seznam'],
      ['check','Když nechceš dostat stejné dárky dvakrát.','nech známé rezervovat dárky']
    ]
  end

  def glyphs
  end
end
