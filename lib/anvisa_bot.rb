require "anvisa_browser"
require "anvisa_parser"

class AnvisaBot

  #veja o fluxo de "navegacao" do bot no arquivo fluxo_site_anvisa.txt
  def self.consulta_produto_por_registro(numero_registro)
    begin
      anvisa_browser = create_anvisa_browser
      plain_html = anvisa_browser.consulta_produto_por_registro(numero_registro)

      #puts "ZZZ ... ~10 segs"
      #sleep( rand(10) )    #para não chamar atencao do server

      links = AnvisaParser.find_links_produtos(plain_html)
      return Produto.new({:not_found => true}) if links.empty?

      plain_html = anvisa_browser.consulta_produto_detalhe(numero_registro, links.first)
      AnvisaParser.extract_produto(plain_html)
    rescue => ex
      Produto.new({:error => ex})
    end
  end

  #usado para injetar stubs ao rodar specs
  def self.create_anvisa_browser
    AnvisaBrowser.new
  end

end

