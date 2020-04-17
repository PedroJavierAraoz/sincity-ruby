class Estado
  attr_reader :viento
  attr_reader :nubosidad
  attr_reader :es_feriado
  attr_reader :precio_kw_mundial

  def initialize(viento:, nubosidad:, estacion:, feriado:, precio_kw_mundial:)
    @energia = 0
    @viento = viento
    @nubosidad = nubosidad
    @estacion = estacion
    @es_feriado = feriado
    @precio_kw_mundial = precio_kw_mundial
  end

  def horas_de_sol
    @estacion.horas_de_sol
  end

  def energia_producida
    @energia
  end

  def producido(energia)
    @energia += energia
  end
end

class Estacion
  attr_reader :horas_de_sol

  def initialize(horas_de_sol:)
    @horas_de_sol = horas_de_sol
  end
end

Verano = Estacion.new(horas_de_sol: 13)
