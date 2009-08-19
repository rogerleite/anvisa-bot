$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib")

require "anvisa_parser"
require "anvisa_browser"
require "anvisa_bot"

describe "AnvisaParser" do

  def read_html(url)
    url = File.dirname(__FILE__) + "/#{url}"
    open(url)
  end

  it "após busca válida, deve encontrar link do produto pesquisado" do
    html = read_html('anvisa_parser_rconsulta_produto_internet_OK.asp.html')
    links = AnvisaParser.find_links_produtos(html)
    links.size.should eql(1)

    link_valido = links.first
    link_valido.codigo.should eql('302629')
    link_valido.empresa.should eql('LABORAT%C3%93RIOS%20B.%20BRAUN%20S/A')
    link_valido.cnpj.should eql('31673254000102')
  end

  it "após busca inválida, deve retornar zero links" do
    html = read_html('anvisa_parser_rconsulta_produto_internet_NAO_OK.asp.html')
    links = AnvisaParser.find_links_produtos(html)
    links.size.should eql(0)
  end

  it "ao consultar produto, deve retornar detalhes do mesmo" do
    html = read_html('anvisa_parser_rconsulta_produto_detalhe.asp.html')
    produto = AnvisaParser.extract_produto(html)

    produto.empresa.should eql('LABORATÓRIOS B. BRAUN S/A')
    produto.cnpj.should eql('31.673.254/0001-02')
    produto.autorizacao.should eql('8013699')
    produto.nome.should eql('CANULA DE VERESS AESCULAP')
    produto.modelo.should eql("- Embalagem individual em 03(tres) apresentaçoes\n\n")
    produto.registro.should eql('10008530225')
    produto.processo.should eql('25000.000651/99-61')
    produto.origem.should eql("FABRICANTE : AESCULAP AG - ALEMANHA\n")
    produto.vencimento_registro.should eql('11/3/2014')

    produto.error?.should eql(false)
    produto.error.should be_nil
    produto.not_found?.should eql(false)
  end

  it "quando ocorrer algum problema, retornar o erro no objeto produto" do

    AnvisaBot.stub!(:create_anvisa_browser).and_return {
      a = AnvisaBrowser.new
      a.stub!(:consulta_produto_por_registro).and_return {
        raise "fake exception"
      }
      a
    }

    produto = AnvisaBot.consulta_produto_por_registro(12345678)
    produto.error?.should eql(true)
    produto.error.should_not be_nil
  end

  it "quando ocorrer nao encontrar o registro na anvisa, retornar not_found no objeto produto" do

    AnvisaBot.stub!(:create_anvisa_browser).and_return {
      a = AnvisaBrowser.new
      a.stub!(:consulta_produto_por_registro).and_return {
        read_html('anvisa_parser_rconsulta_produto_internet_NAO_OK.asp.html')
      }
      a
    }

    produto = AnvisaBot.consulta_produto_por_registro('10008530225')
    produto.not_found?.should eql(true)
  end

end

