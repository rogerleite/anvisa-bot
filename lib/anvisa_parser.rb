require "rubygems"
require "hpricot"

class AnvisaParser

  DEBUG = false

  def self.find_links_produtos(plain_html)
    html = Hpricot(plain_html)
    links = []
    html.search('a[@href*="ver_detalhes"]').each do |link|
      #link['href'] returns:
      #javascript:ver_detalhes('302629','LABORAT%C3%93RIOS%20B.%20BRAUN%20S/A','31673254000102');
      params = link['href'].scan(/'([^']*)'/) #ER, pega os valores que estão dentro das ''
      links << LinkProduto.new(params[0].to_s, params[1].to_s, params[2].to_s)
    end
    links
  end

  def self.extract_produto(plain_html)
    html = Hpricot(plain_html)

    table = html.at("table.formulario")
    #devido a html errado da anvisa (ln 106 e 116), subo dois niveis e ignoro o primeiro td
    table = table.parent.parent.parent

    values = []
    ignore_first = true
    table.search("td").each do |td|
      if ignore_first
        ignore_first = false
        next
      end
      if DEBUG
        puts '=== td.inner_html ==='
        puts td.inner_html
      end
      value = td.inner_html
      value.gsub!(/&nbsp;/, ' ')    #substitui o espaco do html por espaco
      value.strip!                   #remove espacos adicionais
      value.gsub!(/(<br>|<br\s\/>)/, "\n")
      value.gsub!(/<[^>]*>/, '')    #remove qualquer tag restante
      values << value
    end


    Produto.new(:empresa  => values[0], :cnpj   => values[1], :autorizacao  => values[2],
                :nome     => values[3], :modelo => values[4], :registro     => values[5],
                :processo => values[6], :origem => values[7], :vencimento_registro  => values[8])
  end

end

class LinkProduto

  attr_accessor :codigo, :empresa, :cnpj

  def initialize(codigo, empresa, cnpj)
    @codigo = codigo
    @empresa = empresa
    @cnpj = cnpj
  end

end

class Produto

  attr_accessor :empresa, :cnpj, :autorizacao,
                  :nome, :modelo, :registro,
                  :processo,:origem, :vencimento_registro

  def initialize(args)
    raise ArgumentError("Args have to be a Hash with attributes") unless args.is_a?(Hash)
    args.each do |att, value|
      self.send("#{att}=", value)
    end
  end

end

