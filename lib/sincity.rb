class Ciudad
  def initialize
    @construccion = []
  end

  def construir(construccion)
    @construccion.push(construccion)
  end

  def simular_dia(estado)
    @construccion.each { |construccion| construccion.simular_dia(estado) }
  end
end

class Planta
  def calcular_energia_producida(estado)
    raise "subclass responsibility"
  end

  def simular_dia(estado)
    estado.producido(calcular_energia_producida(estado))
  end
end

class PlantaEolica < Planta
  def calcular_energia_producida(estado)
    estado.viento * 3
  end
end

class PlantaFosil < Planta
  def initialize(nro_empleados, kws_hora_por_empleado)
    @nro_empleados = nro_empleados
    @kws_hora_por_empleado = kws_hora_por_empleado
  end

  def kw_por_hora
    @nro_empleados * @kws_hora_por_empleado
  end

  def calcular_energia_producida(estado)
    kw_por_hora * 24
  end
end

class PlantaSolar < Planta
  def initialize(kw_por_hora, gestion:)
    @kw_por_hora = kw_por_hora
    @gestion = gestion
  end

  def calcular_energia(estado)
    estado.nubosidad * @kw_por_hora * estado.horas_de_sol
  end

  def calcular_energia_producida(estado)
    @gestion.calcular(estado, calcular_energia(estado))
  end
end

class Gestion
  def factor(estado)
    raise "subclass responsibility"
  end

  def calcular(estado, energia)
    energia * factor(estado)
  end
end

class GestionPublica < Gestion
  def factor(estado)
    estado.es_feriado ? 0.5 : 1
  end
end

class GestionPrivada < Gestion
  def factor(estado)
    estado.precio_kw_mundial > 10 ? 1 : 0
  end
end