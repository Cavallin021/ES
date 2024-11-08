# Part 01
def palindrome?(string)
  #Atribui a variável 'cleaned_string' a string inserida, com todas as letras minúsculas e remove caracteres indesejados
  cleaned_string = string.downcase.gsub(/\W/, '')
  #Compara os valores de 'cleaned_string' com seu inverso,utilizando o método 'reverse'
  cleaned_string == cleaned_string.reverse
end

def count_words(string)
  #Atribui a variável "word" a string inserida, com todas as letras minúsculas e analisa em busca de palavras
  #A expressão '.scan(/\b\w+\b/)' especifica quando a palavra inicia e termina '\b' e que a palavra pode ter mais de um caractere '\w+'
  words = string.downcase.scan(/\b\w+\b/)
  #Realiza um iteração em cada palavra na lista 'words' e armazena a contagem em no 'Hash', '.new(0)' garante que novas palavras iniciam a contagem em 0
  words.each_with_object(Hash.new(0)) do |word, counts|
    counts[word] += 1
  end
end

#Part 02

class WrongNumberOfPlayersError < StandardError ; end
class NoSuchStrategyError < StandardError ; end

def rps_game_winner(game)
  #Caso o numero de players for diferente de 2 o programa exibe o erro 'WrongNumberOfPlayersError'
  raise WrongNumberOfPlayersError unless game.length == 2
  
  #Atribui os parametros passados aos seus respectivos players
  player1_name, player1_strategy = game[0]
  player2_name, player2_strategy = game[1]
  
  #Nesse momento é normalizado os valores para não haver inconsistencia em maiusculo e minusculo(.upcase)
  player1_strategy = player1_strategy.upcase
  player2_strategy = player2_strategy.upcase
  
  #Caso qualquer uma das estratégias forem diferentes das permitidas, o erro 'NoSuchStrategyError' ocorre
  valid_strategies = ["R", "P", "S"]
  unless valid_strategies.include?(player1_strategy) && valid_strategies.include?(player2_strategy)
    raise NoSuchStrategyError
  end

  #Laço if de comparação padrão em todas as linguagens de programação
  if player1_strategy == player2_strategy
    #Por determinação, estratégias iguais dão a vitória para o player1
    return [player1_name, player1_strategy]
  elsif (player1_strategy == "R" && player2_strategy == "S") ||
        (player1_strategy == "S" && player2_strategy == "P") ||
        (player1_strategy == "P" && player2_strategy == "R")
    return [player1_name, player1_strategy]
  else
    return [player2_name, player2_strategy]
  end
end


def rps_tournament_winner(tournament)
  #Verifica se há arrays o suficiente para haver torneio ou se será uma rodada única.
  #Os dois casos de tournament sendo verdadeiros determina duas rodadas, ou seja, quatro players
  if tournament[0].is_a?(Array) && tournament[0][0].is_a?(Array)
    #Determina os vencedores da primeira rodada, através de recursividade
    winner1 = rps_tournament_winner(tournament[0])
    winner2 = rps_tournament_winner(tournament[1])
    
    #Determina o vencedor final do torneio por recursividade do código anterior
    return rps_game_winner([winner1, winner2])
  else
    #Em caso de rodada única, essa etapa é realizada diretamente
    return rps_game_winner(tournament)
  end
end


#Part 03
def combine_anagrams(words)
  # Cria um hash para agrupar anagramas
  anagram_groups = Hash.new { |hash, key| hash[key] = [] }

  # Itera sobre cada palavra
  words.each do |word|
    # Ordena a palavra e ignora diferenças de maiúsculas/minúsculas
    sorted_word = word.downcase.chars.sort.join
    # Adiciona a palavra ao grupo correspondente no hash
    anagram_groups[sorted_word] << word
  end

  # Retorna os valores do hash, que são os grupos de anagramas
  anagram_groups.values
end


#Part 04
class Dessert
  # Atributos de instância: name e calories
  attr_accessor :name, :calories

  # Construtor da classe, inicializando nome e calorias
  def initialize(name, calories)
    @name = name        # Atribui o nome passado ao atributo @name
    @calories = calories # Atribui o valor de calorias passado ao atributo @calories
  end

  # Método que retorna true se o número de calorias for menor que 200
  def healthy?
    # Verifica se as calorias são menores que 200
    @calories < 200
  end

  # Método que sempre retorna true, indicando que todos os doces são deliciosos
  def delicious?
    true
  end
end


class JellyBean < Dessert
  attr_accessor :flavor  # Adicionando getter e setter para flavor

  # Construtor para inicializar nome, calorias e sabor
  def initialize(name, calories, flavor)
    super(name, calories)  # Chama o construtor da classe Dessert
    @flavor = flavor        # Atribui o sabor específico ao JellyBean
  end

  # Método modificado para JellyBean que retorna false se o sabor for black licorice
  def delicious?
    # Se o sabor for "black licorice", o JellyBean não é delicioso
    if @flavor.downcase == "black licorice"
      return false
    else
      return true
    end
  end
end


#Part 05
class Class
  # Define o método attr_accessor_with_history que cria um getter, setter e histórico para um atributo
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s  # Converte o nome do atributo para uma string (caso seja passado como símbolo)
    ivar_name = "@#{attr_name}"  # Gera o nome da variável de instância (por exemplo, "@bar")

    # Define o getter para o atributo (cria um método para obter o valor do atributo)
    attr_reader attr_name
    
    # Define o getter para o histórico do atributo (cria um método para obter o histórico do atributo)
    attr_reader "#{attr_name}_history"

    # Usamos class_eval para definir dinamicamente o setter e acompanhar o histórico
    class_eval %Q(
      #Define o setter para o atributo, que vai atualizar o valor e registrar o histórico
      def #{attr_name}=(value)
        @#{attr_name}_history ||= [nil]  # Inicializa o histórico com [nil] caso seja a primeira vez que o valor é atribuído
        @#{attr_name}_history << value   # Adiciona o novo valor ao histórico
        @#{attr_name} = value            # Atribui o valor ao atributo (variável de instância)
      end
    )
  end
end


#Part 06
class Numeric
  # Dicionário de conversões para dólares
  @@currencies = {
    'yen' => 0.013,   # 1 yen = 0.013 dólares
    'euro' => 1.292,  # 1 euro = 1.292 dólares
    'rupee' => 0.019, # 1 rupee = 0.019 dólares
    'dollar' => 1     # 1 dólar = 1 dólar (para simplificação)
  }

  # Método que lida com as conversões ao chamar uma moeda
  def method_missing(method_id)
    # Remove o "s" no final da moeda, para que aceitemos tanto o singular quanto o plural
    singular_currency = method_id.to_s.gsub(/s$/, '')
    
    # Se a moeda existir no dicionário, multiplica pelo valor da conversão
    if @@currencies.has_key?(singular_currency)
      # Retorna o valor em dólares da moeda
      self * @@currencies[singular_currency]
    else
      super
    end
  end

  # Método in para realizar a conversão entre moedas
  def in(currency)
    # Remove o "s" no final da moeda, para aceitar tanto singular quanto plural
    singular_currency = currency.to_s.gsub(/s$/, '')
    
    # Verifica se a moeda de destino está no dicionário
    if @@currencies.has_key?(singular_currency)
      # Retorna o valor da moeda convertido para a moeda de destino
      self / @@currencies[singular_currency]
    else
      raise "Currency #{currency} not supported"
    end
  end
end


class String
  def palindrome?
    self == self.reverse
  end
end


module Enumerable
  def palindrome?
    self == self.reverse
  end
end