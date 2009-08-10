require 'net/http'
require 'uri'

class AnvisaBrowser

  ANVISA_URL = 'http://www7.anvisa.gov.br/datavisa/Consulta_Produto_correlato/'
  USER_AGENT = "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.13) Gecko/2009080315 Ubuntu/9.04 (jaunty) Firefox/3.0.13"
  DEBUG_REQ = false

  class << self
		attr_accessor :default_headers
	end
	self.default_headers = {
	  'User-Agent' => USER_AGENT,
    'Accept'     => 'text/html',
    'Accept-Charset' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7'
  }

  def consulta_produto_por_registro(numero_registro)
    plain_url = "#{ANVISA_URL}rconsulta_produto_internet.asp"
    params = {
      :CO_TIPO_PRODUTO => '8',  :Area => 'Cosmético', :Processo => '',
      :Produto => '',           :CNPJ => '',          :NO_EMPRESA => '',
      :Registro => numero_registro
    }

    user_headers = {
      'Referer' => 'http://www7.anvisa.gov.br/datavisa/Consulta_Produto_correlato/consulta_correlato.asp'
    }

    simple_post(plain_url, params, user_headers)
  end

  def consulta_produto_detalhe(numero_registro, link_produto)
    plain_url = "#{ANVISA_URL}rconsulta_produto_detalhe.asp"
    params = {
      :CO_PRODUTO => link_produto.codigo,
      :NO_EMPRESA => link_produto.empresa,
      :NU_CNPJ    => link_produto.cnpj,
      :REGISTRO   => numero_registro,
      :NU_PROCESSO  => '',
      :NO_PRODUTO   => '',
      :NU_REGISTRO  => '',
      :NU_AUTORIZACAO   => '',
      :CO_TIPO_PRODUTO  => '8',
      :hdnpgAtual => '1',
      :hdnmodo    => '',
      :PROCESSO   => '',
      :PRODUTO    => '',
      :EMPRESA    => '',
      :CNPJ       => ''
    }

    user_headers = {
      'Referer' => 'http://www7.anvisa.gov.br/datavisa/Consulta_Produto_correlato/consulta_correlato.asp'
    }

    simple_post(plain_url, params, user_headers)
  end

  private
  # Faz um post simples e retorna o "plain html" da pagina.
  # fonte: http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/classes/Net/HTTP.html
  def simple_post(plain_url, params, user_headers)
    url = URI.parse(plain_url)

    headers = self.class.default_headers.merge(user_headers)

    req = Net::HTTP::Post.new(url.path, headers)
    req.set_form_data(params)

    if DEBUG_REQ
      puts "=== Debug Http Request"
      puts "url  => #{url}"
      puts "body => #{req.body}"
      puts "=== Fim Debug Http Request"
    end

    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        # OK
      else
        res.error!
    end

    plain_html = res.body
    if DEBUG_REQ
      puts "=== Debug Http Response Body"
      puts plain_html
      puts "=== Fim Debug Http Response Body"
    end
    plain_html
  end

  def make_headers(user_headers)
    self.class.default_headers.merge(user_headers)
  end

end

